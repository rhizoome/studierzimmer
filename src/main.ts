import * as inkjs from 'inkjs';
import { Mixer } from './sound';
import { Activity } from './activity';
import storyContent from '../temp/studierzimmer.json';

class StoryRunner {
    private story: inkjs.Story;
    private theme: string = "dark";
    private savePoint: string = "";
    private storyContainer: HTMLElement;
    private rewindButton: HTMLElement;
    private saveButton: HTMLElement;
    private loadButton: HTMLElement;
    private mixer: Mixer = new Mixer();
    private loadPromises: Record<string, Promise<void>> = {};
    private activityTracker: Activity = new Activity();
    private tag: string = "p";

    constructor(storyContent: any) {
        this.story = new inkjs.Story(storyContent);
        this.story.BindExternalFunction("setTheme", this.updateTheme.bind(this));
        this.story.BindExternalFunction("createSlot", this.createSlot.bind(this));
        this.story.BindExternalFunction("loadSound", this.loadSound.bind(this));
        this.story.BindExternalFunction("playSound", this.playSound.bind(this));
        this.story.BindExternalFunction("playSoundS", this.playSoundS.bind(this));
        this.story.BindExternalFunction("playSoundV", this.playSoundV.bind(this));
        this.story.BindExternalFunction("stopSound", this.stopSound.bind(this));
        this.story.BindExternalFunction("currentSound", this.currentSound.bind(this));
        this.story.BindExternalFunction("stopAllSounds", this.stopAllSounds.bind(this));
        this.story.BindExternalFunction("stopGroup", this.stopGroup.bind(this));
        this.story.BindExternalFunction("setFadeTime", this.setFadeTime.bind(this));
        this.story.BindExternalFunction("keepSoundAlive", this.keepSoundAlive.bind(this));
        this.story.BindExternalFunction("hasFrontend", this.hasFrontend.bind(this), true);
        this.story.BindExternalFunction("activity", this.activity.bind(this));
        this.story.BindExternalFunction("cap", this.capitalize.bind(this), true);
        this.storyContainer = document.querySelector("#target") as HTMLElement;
        this.rewindButton = document.querySelector("#rewind") as HTMLElement;
        this.saveButton = document.querySelector("#save") as HTMLElement;
        this.loadButton = document.querySelector("#load") as HTMLElement;
        const scroll = document.querySelector("#outerContainer") as HTMLElement;
        scroll.addEventListener("scroll", this.activityTracker.track.bind(this.activityTracker));
        this.wireButtons();
        this.globalTags();
    }

    public init(): void {
        this.renderParagraphs();
        this.storyContainer.innerHTML = "";
        this.load();
        this.run();
    }

    private run(): void {
        this.savePoint = this.story.state.toJson();
        this.renderParagraphs();
        this.renderChoices();
        this.show();
    }

    private globalTags(): void {
        const globalTags = this.story.globalTags;

        if (globalTags) {
            globalTags.forEach((tag: string) => {
                const { key, value } = this.processTag(tag);
                switch (key.toLowerCase()) {
                    case 'title':
                        this.setInnerHTML("#title", value);
                        break;
                    case 'author':
                        this.setInnerHTML("#byline", "von " + value);
                        break;
                    case 'theme':
                        this.updateTheme(value);
                        break;
                    default:
                        console.warn(`Unhandled Tag - ${key}: ${value}`);
                }
            });
        }
    }

    private parseTags(tags: string[] | null, customClasses: string[]): void {
        if (tags) {
            tags.forEach((tag: string) => {
                const { key, value } = this.processTag(tag);
                switch (key.toLowerCase()) {
                    case 'class':
                        customClasses.push(value);
                        break;
                    case 'tag':
                        this.tag = value;
                        break;
                    // Ignore global tags - ink will repeat thems
                    case 'title':
                    case 'author':
                    case 'theme':
                        break;
                    default:
                        console.warn(`Unhandled Tag - ${key}: ${value}`);
                }
            });
        }
    }

    private renderParagraphs(): void {
        while (this.story.canContinue) {
            const paragraph = this.story.Continue();
            const customClasses: string[] = [];
            this.parseTags(this.story.currentTags, customClasses);
            if (!paragraph || !paragraph.trim()) {
                continue;
            }
            const el = document.createElement('p');
            el.classList.add("blend");
            el.innerHTML = this.markUp(paragraph);
            customClasses.forEach(cls => el.classList.add(cls));
            el.classList.add("hide");
            this.storyContainer.appendChild(el);
        }
    }

    private renderChoices(): void {
        const last = this.story.currentChoices.slice(-1)[0];
        let lastTag: string | null = null;
        this.story.currentChoices.forEach((choice: any) => {
            const customClasses: string[] = [];
            this.parseTags(choice.tags, customClasses);
            console.log(choice.text, this.tag);

            const cel = document.createElement(this.tag);
            cel.classList.add("blend");
            cel.classList.add("choice");
            let prefix = ""
            if (this.tag == "span" && lastTag == "span") {
                prefix = ", ";
            }
            lastTag = this.tag;
            cel.innerHTML = prefix + `<a>${choice.text}</a>`;
            customClasses.forEach(cls => cel.classList.add(cls));
            cel.classList.add("hide");
            this.storyContainer.appendChild(cel);
            cel.scrollIntoView({
                behavior: 'smooth',
                block: 'center',
                inline: 'nearest',
            });
            const ael = cel.querySelector("a");
            if (ael) {
                ael.addEventListener("click", (event: MouseEvent) => {
                    this.removeAll(".choice");
                    this.story.ChooseChoiceIndex(choice.index);
                    this.savePoint = this.story.state.toJson();
                    this.run();
                });
            }
        });
    }

    // Helpers

    private wireButtons(): void {
        this.rewindButton.addEventListener("click", (event: MouseEvent) => {
            this.restart();
        });
        this.saveButton.addEventListener("click", (event: MouseEvent) => {
            this.save();
        });
        this.loadButton.addEventListener("click", (event: MouseEvent) => {
            this.load();
            this.init();
        });
    }

    private restart(): void {
        this.storyContainer.innerHTML = "";
        this.story.ResetState();
        this.mixer.stopAll();
        this.run();
    }

    public load(): void {
        const savedState = window.localStorage.getItem('save-state');
        if (savedState) {
            this.story.state.LoadJson(savedState);
        }
    }

    private save(): void {
        window.localStorage.setItem('save-state', this.savePoint);
    }

    private show(): void {
        const elements = document.querySelectorAll(".hide");
        if (elements) {
            const el = elements.item(0);
            if (el) {
                el.classList.remove("hide");
                setTimeout(this.show.bind(this), 250);
            }
        }
    }

    private removeAll(selector: string): void {
        const allElements = this.storyContainer.querySelectorAll(selector);
        allElements.forEach(el => el.parentNode?.removeChild(el));
    }

    private setInnerHTML(query: string, value: string): void {
        const tag = document.querySelector(query);
        if (tag) {
            tag.innerHTML = value;
        }
    }

    private processTag(tag: string): { key: string; value: string } {
        const [key, value] = tag.split(':').map(part => part.trim());
        return { key, value };
    }

    private updateTheme(theme: string): void {
        const cl = document.documentElement.classList;
        cl.add("switched");
        cl.remove("theme-" + this.theme);
        cl.add("theme-" + theme);
        this.theme = theme;
    }

    private markUp(input: string): string {
        return input.replace(/_(.+?)_/g, (match, p1) => `<b>${p1}</b>`);
    }

    // Bindings

    private keepSoundAlive(): void {
        this.mixer.startDummy();
    }

    private createSlot(name: string, loop: boolean = false, groupList: string = ""): void {
        const list = groupList.split(",").map(item => item.trim());
        this.mixer.createSlot(name, loop, list);
    }

    private loadSound(slotName: string, soundName: string, url: string): void {
        const name = slotName + soundName;
        const promise = this.mixer.load(slotName, soundName, url);
        this.loadPromises[name] = promise;
    }

    private playSoundS(slotName: string, soundName: string): void {
        this.playSound(slotName, soundName);
    }

    private playSoundV(slotName: string, soundName: string, volume: number = 1): void {
        this.playSound(slotName, soundName, volume);
    }

    private playSound(slotName: string, soundName: string, volume: number = 1, crossFade: boolean = true): void {
        (async () => {
            const name = slotName + soundName;
            await this.loadPromises[name];
            this.mixer.play(slotName, soundName, volume, crossFade);
        })();
    }

    private stopSound(slotName: string): void {
        this.mixer.stop(slotName);
    }

    private currentSound(slotName: string): string {
        return this.mixer.current(slotName);
    }

    private stopAllSounds(): void {
        this.mixer.stopAll();
    }

    private stopGroup(groupName: string): void {
        this.mixer.stopGroup(groupName);
    }

    private setFadeTime(time: number): void {
        this.mixer.setFadeTime(time);
    }

    private hasFrontend(): boolean {
        return true;
    }

    private activity(): number {
        return this.activityTracker.activity();
    }

    private capitalize(input: string): string {
        if (!input) {
            return "";
        }
        return input.charAt(0).toUpperCase() + input.slice(1);
    }
}

function runStory(): void {
    const runner = new StoryRunner(storyContent);
    runner.init();
}


export { runStory };
