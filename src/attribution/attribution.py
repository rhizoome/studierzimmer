import hashlib
import json
import logging
import pickle
import shutil
import sys
from pathlib import Path

import click
import jinja2
import requests
from bs4 import BeautifulSoup
from platformdirs import user_cache_dir

logging.basicConfig(stream=sys.stderr, level=logging.INFO)
log = logging.getLogger(__package__)

cache_dir = Path(user_cache_dir("attribution"))
log.info(f"using cache: {cache_dir}")
cache_dir.mkdir(parents=True, exist_ok=True)
static_id = "733927"
base = "https://freesound.org"
search_query = f"{base}/search/?q={{id}}"
file_types = set((".mp3", ".wav", ".flac", ".m4a", ".ogg"))


def hash(*args, **kwargs):
    key_data = pickle.dumps((args, kwargs))
    return hashlib.sha256(key_data).hexdigest()


def cache(**kwargs):
    value = kwargs["value"]
    kwargs.pop("value")
    key_hash = hash(kwargs)
    cache_path = Path(cache_dir, key_hash)
    with cache_path.open("wb") as f:
        pickle.dump(value, f)


def load(**kwargs) -> any:
    key_hash = hash(kwargs)
    cache_path = Path(cache_dir, key_hash)
    if cache_path.exists():
        log.info(f"cache {key_hash[:8]} found for: {kwargs}")
        with cache_path.open("rb") as f:
            return pickle.load(f)
    else:
        return None


def cache_get(url: str) -> requests.Response:
    if r := load(url=url):
        return r
    response = requests.get(url)
    if response.status_code == 200:
        cache(url=url, value=response.text)
        return response.text
    else:
        raise ValueError(f"HTTP error {response.status_code}")


def freesound_search_results(id: str) -> str:
    query_url = search_query.format(id=id)
    return cache_get(query_url)


def extract_search_result_url(html: str) -> str:
    soup = BeautifulSoup(html, "html.parser")
    result_div = soup.find("div", class_="bw-search__result")
    anchor = result_div.find("a", class_="bw-link--black")
    return f"{base}{anchor['href']}"


def fetch_ids(path: Path):
    result = []
    for file in path.iterdir():
        if not file.is_file:
            continue
        if file.suffix in file_types:
            ids = file.name.split("__")[:-1]
            for id in ids:
                try:
                    int(id)
                    result.append(id.strip())
                except ValueError:
                    pass
    return set(result)


def extract_html_attribution(html):
    soup = BeautifulSoup(html, "html.parser")
    for option in soup.findAll("option"):
        if option.text.strip() == "HTML":
            return option["value"].strip()


def template_attribution(path, template, lines):
    env = jinja2.Environment(
        loader=jinja2.FileSystemLoader(path),
    )
    template = env.get_template(template)
    return template.render(attribution=lines)


@click.group()
def cli():
    pass


@cli.command()
def clear_cache():
    shutil.rmtree(cache_dir)


@cli.command()
@click.argument(
    "path",
    nargs=1,
    type=click.Path(
        exists=True,
        file_okay=False,
        dir_okay=True,
        readable=True,
    ),
)
@click.argument(
    "file",
    nargs=1,
    type=click.Path(
        file_okay=True,
        dir_okay=False,
        writable=True,
    ),
)
def read(path, file):
    path = Path(path).absolute()
    file = Path(file).absolute()
    ids = fetch_ids(path)
    lines = []
    for id in sorted(ids):
        url = extract_search_result_url(freesound_search_results(id))
        attribution = cache_get(f"{url}attribution/?ajax=1")
        lines.append(extract_html_attribution(attribution))

    with file.open("w") as f:
        json.dump(lines, f, indent=4)


@cli.command()
@click.argument(
    "templates",
    nargs=1,
    type=click.Path(
        exists=True,
        file_okay=False,
        dir_okay=True,
        readable=True,
    ),
)
@click.argument(
    "file",
    nargs=1,
    type=str,
)
@click.argument(
    "json_file",
    nargs=1,
    type=click.Path(
        file_okay=True,
        dir_okay=False,
        readable=True,
    ),
)
@click.argument(
    "out",
    nargs=1,
    type=click.Path(
        file_okay=True,
        dir_okay=False,
        writable=True,
    ),
)
def template(templates, file, json_file, out):
    templates = Path(templates).absolute()
    json_file = Path(json_file).absolute()
    out = Path(out).absolute()
    with json_file.open("r") as f:
        lines = json.load(f)
    result = template_attribution(templates, file, lines)
    with out.open("w") as f:
        f.write(result)
