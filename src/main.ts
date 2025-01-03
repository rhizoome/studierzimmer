import * as inkjs from 'inkjs';
import storyContent from '../temp/studierzimmer.json';

class StoryRunner {
    private story: inkjs.Story;
    private theme: string = "dark";
    private savePoint: string = "";
    private showList: HTMLElement[] = [];
    private storyContainer: HTMLElement;
    private firstTags: boolean = true;

    constructor(storyContent: any) {
        this.story = new inkjs.Story(storyContent);
        this.story.BindExternalFunction("setTheme", this.updateTheme.bind(this));
        this.storyContainer = document.querySelector("#story") as HTMLElement;
        this.globalTags();
    }

    public run(): void {
        this.renderParagraphs();
        this.renderChoices();
        this.show()
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
        if (this.firstTags) {
            this.firstTags = false;
            return;
        }
        if (tags) {
            tags.forEach((tag: string) => {
                const { key, value } = this.processTag(tag);
                switch (key.toLowerCase()) {
                    case 'class':
                        customClasses.push(value);
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
            el.innerHTML = paragraph;
            customClasses.forEach(cls => el.classList.add(cls));
            el.classList.add("hide");
            this.storyContainer.appendChild(el);
        }
    }

    private renderChoices(): void {
        this.story.currentChoices.forEach((choice: any) => {
            const customClasses: string[] = [];
            this.parseTags(choice.tags, customClasses);

            const cel = document.createElement('p');
            cel.classList.add("blend");
            cel.classList.add("choice");
            cel.innerHTML = `<a href='#'>${choice.text}</a>`;
            customClasses.forEach(cls => cel.classList.add(cls));
            cel.classList.add("hide");
            this.storyContainer.appendChild(cel);
            cel.scrollIntoView({
                behavior: 'smooth', // Smooth scrolling animation
                block: 'center',    // Scroll so the element is centered in the viewport
                inline: 'nearest',  // Default for horizontal scrolling
            });
            const ael = cel.querySelector("a");
            if (ael) {
                ael.addEventListener("click", (event: MouseEvent) => {
                    event.preventDefault();
                    this.removeAll(".choice");
                    this.story.ChooseChoiceIndex(choice.index);
                    this.savePoint = this.story.state.toJson();
                    this.run();
                });
            }
        });
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
}

function runStory(): void {
    const runner = new StoryRunner(storyContent);
    runner.run();
}

import { Mixer } from './sound'; // TODO remove

export { runStory, Mixer };
