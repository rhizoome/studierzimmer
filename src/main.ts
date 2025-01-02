import * as inkjs from 'inkjs';
import storyContent from '../temp/studierzimmer.json';


class StoryRunner {
    private story: any;
    private previousBottomEdge: number = 0;
    private delay: number = 0.0;
    private savePoint: string = "";
    private globalTagTheme?: string;

    private storyContainer: HTMLElement;
    private outerScrollContainer: HTMLElement;

    constructor(private storyContent: any) {
        this.story = new inkjs.Story(storyContent);

        // Bind external functions
        this.story.BindExternalFunction("setOutsideTheme", this.setOutsideTheme);

        // Grab references to DOM elements
        this.storyContainer = document.querySelector('#story') as HTMLElement;
        this.outerScrollContainer = document.querySelector('.outerContainer') as HTMLElement;
    }

    public run(): void {
        const globalTags = this.story.globalTags;
        if (globalTags) {
            for (let i = 0; i < globalTags.length; i++) {
                const globalTag = globalTags[i];
                const splitTag = this.splitPropertyTag(globalTag);

                if (splitTag && splitTag.property === "theme") {
                    this.globalTagTheme = splitTag.val;
                }
                else if (splitTag && splitTag.property === "author") {
                    const byline = document.querySelector('.byline') as HTMLElement;
                    if (byline) {
                        byline.innerHTML = "von " + splitTag.val;
                    }
                }
            }
        }

        // Page features setup
        this.setupTheme(this.globalTagTheme);

        // Load any existing save
        const hasSave = this.loadSavePoint();

        // Hook up top-level buttons (save, reload, etc.)
        this.setupButtons(hasSave);

        // Set initial save point
        this.savePoint = this.story.state.toJson();

        // Kick off the start of the story
        this.continueStory(true);
    }

    private setOutsideTheme(dark: boolean) {
        document.body.classList.add("switched");
        if (dark) {
            document.body.classList.add("dark");
        } else {
            document.body.classList.remove("dark");
        }
    }

    private continueStory(firstTime: boolean): void {
        this.previousBottomEdge = firstTime ? 0 : this.contentBottomEdgeY();
        this.delay = 0.0;

        this.writeParagraphs();
        this.writeChoices(firstTime);

    }

    private writeChoices(firstTime: boolean) {
        this.story.currentChoices.forEach((choice: any) => {
            const choiceTags = choice.tags;
            const choiceClasses: string[] = [];
            let isClickable = true;

            for (let i = 0; i < choiceTags.length; i++) {
                const choiceTag = choiceTags[i];
                const splitTag = this.splitPropertyTag(choiceTag);

                if (choiceTag.toUpperCase() === "UNCLICKABLE") {
                    isClickable = false;
                }

                if (splitTag && splitTag.property.toUpperCase() === "CLASS") {
                    choiceClasses.push(splitTag.val);
                }
            }

            const choiceParagraphElement = document.createElement('p');
            choiceParagraphElement.classList.add("choice");
            choiceClasses.forEach(cls => choiceParagraphElement.classList.add(cls));

            if (isClickable) {
                choiceParagraphElement.innerHTML = `<a href='#'>${choice.text}</a>`;
            } else {
                choiceParagraphElement.innerHTML = `<span class='unclickable'>${choice.text}</span>`;
            }
            this.storyContainer.appendChild(choiceParagraphElement);

            // Fade choice in after a short delay
            this.showAfter(this.delay, choiceParagraphElement);
            this.delay += 200.0;

            // Click on choice
            if (isClickable) {
                const choiceAnchorEl = choiceParagraphElement.querySelector("a");
                if (choiceAnchorEl) {
                    choiceAnchorEl.addEventListener("click", (event: MouseEvent) => {
                        event.preventDefault();

                        // Extend height to fit
                        this.storyContainer.style.height = this.contentBottomEdgeY() + "px";

                        // Remove all existing choices
                        this.removeAll(".choice");

                        // Tell the story where to go next
                        this.story.ChooseChoiceIndex(choice.index);

                        // This is where the save button will save from
                        this.savePoint = this.story.state.toJson();

                        // And continue
                        this.continueStory(false);
                    });
                }
            }
        });

        // Unset storyContainer's height so it can resize
        this.storyContainer.style.height = "";

        if (!firstTime) {
            this.scrollDown();
        }
    }

    private writeParagraphs() {
        while (this.story.canContinue) {
            const paragraphText = this.story.Continue();
            const tags = this.story.currentTags;

            const customClasses: string[] = [];

            for (let i = 0; i < tags.length; i++) {
                const tag = tags[i];
                const splitTag = this.splitPropertyTag(tag);

                if (splitTag && splitTag.property.toUpperCase() === "IMAGE") {
                    const imageElement = document.createElement('img');
                    imageElement.src = splitTag.val;
                    this.storyContainer.appendChild(imageElement);

                    imageElement.onload = () => {
                        this.scrollDown();
                    };

                    this.showAfter(this.delay, imageElement);
                    this.delay += 200.0;
                }
                else if (splitTag && splitTag.property.toUpperCase() === "LINK") {
                    window.location.href = splitTag.val;
                }
                else if (splitTag && splitTag.property.toUpperCase() === "LINKOPEN") {
                    window.open(splitTag.val);
                }
                else if (splitTag && splitTag.property.toUpperCase() === "BACKGROUND") {
                    this.outerScrollContainer.style.backgroundImage = `url(${splitTag.val})`;
                }
                else if (splitTag && splitTag.property.toUpperCase() === "CLASS") {
                    customClasses.push(splitTag.val);
                }
                else if (tag.toUpperCase() === "CLEAR" || tag.toUpperCase() === "RESTART") {
                    this.removeAll("p");
                    this.removeAll("img");

                    // Remove the header too if needed
                    this.setVisible(".header", false);

                    // If RESTART, reset entire story
                    if (tag.toUpperCase() === "RESTART") {
                        this.restart();
                        return;
                    }
                }
            }

            // Skip empty paragraphs
            if (paragraphText.trim().length === 0) {
                continue;
            }

            // Create paragraph element (initially hidden)
            const paragraphElement = document.createElement('p');
            paragraphElement.innerHTML = paragraphText;
            customClasses.forEach(cls => paragraphElement.classList.add(cls));
            this.storyContainer.appendChild(paragraphElement);

            // Fade in paragraph after a short delay
            this.showAfter(this.delay, paragraphElement);
            this.delay += 200.0;
        }
    }

    private restart(): void {
        this.story.ResetState();
        this.setVisible(".header", true);

        this.savePoint = this.story.state.toJson();
        this.continueStory(true);
        this.outerScrollContainer.scrollTo(0, 0);
    }

    // Detect if the user wants animations
    private isAnimationEnabled(): boolean {
        return window.matchMedia('(prefers-reduced-motion: no-preference)').matches;
    }

    // Fades in an element after a specified delay
    private showAfter(delay: number, el: HTMLElement): void {
        if (this.isAnimationEnabled()) {
            el.classList.add("hide");
            setTimeout(() => {
                el.classList.remove("hide");
            }, delay);
        } else {
            // If the user doesn't want animations, show immediately
            el.classList.remove("hide");
        }
    }

    // Scroll the page down, but no further than the bottom edge of previous content
    private scrollDown(): void {
        if (!this.isAnimationEnabled()) {
            return;
        }
        let target = this.previousBottomEdge;

        const limit = this.outerScrollContainer.scrollHeight - this.outerScrollContainer.clientHeight;
        if (target > limit) target = limit;

        const start = this.outerScrollContainer.scrollTop;
        const dist = target - start;
        const duration = 300 + 300 * dist / 100;
        let startTime: number | null = null;

        const step = (time: number) => {
            if (startTime === null) startTime = time;
            const t = (time - startTime) / duration;
            const lerp = 3 * t * t - 2 * t * t * t; // ease in/out
            this.outerScrollContainer.scrollTo(0, (1.0 - lerp) * start + lerp * target);
            if (t < 1) requestAnimationFrame(step);
        };

        requestAnimationFrame(step);
    }

    // The Y coordinate of the bottom end of all the story content
    private contentBottomEdgeY(): number {
        const bottomElement = this.storyContainer.lastElementChild as HTMLElement;
        return bottomElement ? bottomElement.offsetTop + bottomElement.offsetHeight : 0;
    }

    // Remove all elements that match the given selector
    private removeAll(selector: string): void {
        const allElements = this.storyContainer.querySelectorAll(selector);
        allElements.forEach(el => el.parentNode?.removeChild(el));
    }

    // Used for hiding and showing the header
    private setVisible(selector: string, visible: boolean): void {
        const allElements = this.storyContainer.querySelectorAll(selector);
        allElements.forEach(el => {
            if (!visible) el.classList.add("invisible");
            else el.classList.remove("invisible");
        });
    }

    // Parse tags of the form "# PROPERTY: value"
    private splitPropertyTag(tag: string): { property: string; val: string } | null {
        const propertySplitIdx = tag.indexOf(":");
        if (propertySplitIdx >= 0) {
            const property = tag.substr(0, propertySplitIdx).trim();
            const val = tag.substr(propertySplitIdx + 1).trim();
            return { property, val };
        }
        return null;
    }

    // Loads save state if it exists in the browser memory
    private loadSavePoint(): boolean {
        try {
            const savedState = window.localStorage.getItem('save-state');
            if (savedState) {
                this.story.state.LoadJson(savedState);
                return true;
            }
        } catch (e) {
            console.debug("Couldn't load save state");
        }
        return false;
    }

    // Detects which theme (light or dark) to use
    private setupTheme(globalTagTheme?: string): void {
        // load theme from browser memory
        let savedTheme: string | null = null;
        try {
            savedTheme = window.localStorage.getItem('theme');
        } catch (e) {
            console.debug("Couldn't load saved theme");
        }

        // Check whether the OS/browser is configured for dark mode
        const browserDark = window.matchMedia("(prefers-color-scheme: dark)").matches;

        if (savedTheme === "dark"
            || (savedTheme == null && globalTagTheme === "dark")
            || (savedTheme == null && globalTagTheme == null && browserDark)) {
            document.body.classList.add("dark");
        }
    }

    // Wires up the functionality for global buttons
    private setupButtons(hasSave: boolean): void {
        const rewindEl = document.getElementById("rewind");
        if (rewindEl) {
            rewindEl.addEventListener("click", () => {
                this.removeAll("p");
                this.removeAll("img");
                this.setVisible(".header", false);
                this.restart();
            });
        }

        const saveEl = document.getElementById("save");
        if (saveEl) {
            saveEl.addEventListener("click", () => {
                try {
                    window.localStorage.setItem('save-state', this.savePoint);
                    const reloadBtn = document.getElementById("reload");
                    if (reloadBtn) {
                        reloadBtn.removeAttribute("disabled");
                    }
                    window.localStorage.setItem(
                        'theme',
                        document.body.classList.contains("dark") ? "dark" : ""
                    );
                } catch (e) {
                    console.warn("Couldn't save state");
                }
            });
        }

        const reloadEl = document.getElementById("reload");
        if (reloadEl) {
            if (!hasSave) {
                reloadEl.setAttribute("disabled", "disabled");
            }
            reloadEl.addEventListener("click", () => {
                if (reloadEl.getAttribute("disabled")) return;

                this.removeAll("p");
                this.removeAll("img");
                try {
                    const savedState = window.localStorage.getItem('save-state');
                    if (savedState) {
                        this.story.state.LoadJson(savedState);
                    }
                } catch (e) {
                    console.debug("Couldn't load save state");
                }
                this.continueStory(true);
            });
        }

        const themeSwitchEl = document.getElementById("theme-switch");
        if (themeSwitchEl) {
            themeSwitchEl.addEventListener("click", () => {
                document.body.classList.add("switched");
                document.body.classList.toggle("dark");
            });
        }
    }
}

function runStory(): void {
    const runner = new StoryRunner(storyContent);
    runner.run();
}

export { runStory };
