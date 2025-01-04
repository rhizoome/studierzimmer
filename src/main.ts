import * as inkjs from 'inkjs';
import { Mixer } from './sound';
import storyContent from '../temp/studierzimmer.json';

class StoryRunner {
    private story: inkjs.Story;
    private theme: string = "dark";
    private savePoint: string = "";
    private storyContainer: HTMLElement;
    private rewindButton: HTMLElement;
    private saveButton: HTMLElement;
    private loadButton: HTMLElement;
    private firstTags: boolean = true;
    private mixer: Mixer = new Mixer();
    private loadPromises: Record<string, Promise<void>> = {};
    private initDone: boolean = false;

    constructor(storyContent: any) {
        this.story = new inkjs.Story(storyContent);
        this.story.BindExternalFunction("setTheme", this.updateTheme.bind(this));
        this.story.BindExternalFunction("createSlot", this.createSlot.bind(this));
        this.story.BindExternalFunction("loadSound", this.loadSound.bind(this));
        this.story.BindExternalFunction("playSound", this.playSound.bind(this));
        this.story.BindExternalFunction("playSoundS", this.playSoundS.bind(this));
        this.story.BindExternalFunction("playSoundV", this.playSoundV.bind(this));
        this.story.BindExternalFunction("stopSound", this.stopSound.bind(this));
        this.story.BindExternalFunction("stopAllSounds", this.stopAllSounds.bind(this));
        this.story.BindExternalFunction("stopGroup", this.stopGroup.bind(this));
        this.story.BindExternalFunction("setFadeTime", this.setFadeTime.bind(this));
        this.story.BindExternalFunction("keepSoundAlive", this.keepSoundAlive.bind(this));
        this.story.BindExternalFunction("initDone", this.setInitDone.bind(this));
        this.storyContainer = document.querySelector("#target") as HTMLElement;
        this.rewindButton = document.querySelector("#rewind") as HTMLElement;
        this.saveButton = document.querySelector("#save") as HTMLElement;
        this.loadButton = document.querySelector("#load") as HTMLElement;
        this.wireButtons();
        this.globalTags();
    }

    public init(): void {
        this.renderParagraphs();
        this.storyContainer.innerHTML = "";
        this.load();
        this.run();
    }

    public run(): void {
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
            cel.innerHTML = `<a>${choice.text}</a>`;
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
        this.firstTags = true;
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

    // Bindings

    private setInitDone(): void {
        this.initDone = true
    }

    private keepSoundAlive(): void {
        this.mixer.startDummy();
    }

    private createSlot(name: string, loop: boolean = false, groupList: string = ""): void {
        const list = groupList.split(":").map(item => item.trim());
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

    private stopAllSounds(): void {
        this.mixer.stopAll();
    }

    private stopGroup(groupName: string): void {
        this.mixer.stopGroup(groupName);
    }

    private setFadeTime(time: number): void {
        this.mixer.setFadeTime(time);
    }
}

function runStory(): void {
    const runner = new StoryRunner(storyContent);
    runner.init();
}


export { runStory };
