import { sleep } from "./util"

type Slots = Record<string, Slot>;
type Groups = Record<string, Group>;
type Sounds = Record<string, Sound>;

class Config {
    public fadeTime: number = 2;
    public context: AudioContext;
    constructor(context: AudioContext) {
        this.context = context;
    }
}

class SlotNodes {
    public source: AudioBufferSourceNode;
    public gain: GainNode;

    constructor(buffer: AudioBuffer, context: AudioContext) {
        this.gain = context.createGain();
        this.gain.gain.value = 0;
        this.source = context.createBufferSource();
        this.source.connect(this.gain).connect(context.destination);
        this.source.buffer = buffer;
    }
}

class Sound {
    readonly name: string;
    readonly slot: string;
    private buffer: ArrayBuffer | null = null;
    private context: AudioContext;
    private config: Config;

    constructor(name: string, slotName: string, config: Config) {
        this.name = name;
        this.slot = slotName;
        this.context = config.context;
        this.config = config;
    }

    public async load(url: string): Promise<void> {
        try {
            const response = await fetch(url);
            this.buffer = await response.arrayBuffer();
        } catch (error) {
            console.error(`Failed to load sound "${this.name}" in slot "${this.slot}" from "${url}"`, error);
        }
    }

    public async getBuffer(): Promise<AudioBuffer> {
        if (this.buffer) {
            try {
                return await this.context.decodeAudioData(this.buffer.slice(0));
            } catch (error) {
                console.error(`Failed to decode audio data of "${this.name} in "{$this.slot}""`, error);
            }
        }
        console.warn(`Sound "${this.name}" in "${this.slot}" not loaded.`);
        return this.context.createBuffer(2, 1, this.context.sampleRate);
    }
}

class Slot {
    readonly name: string;
    private context: AudioContext;
    private config: Config;
    private nodes: SlotNodes | null = null;
    private nodesSet: Set<SlotNodes> = new Set();
    private sounds: Sounds = {};
    private loop: boolean = false;
    private volume: number = 0;

    constructor(name: string, loop: boolean, config: Config) {
        this.name = name;
        this.loop = loop;
        this.context = config.context;
        this.config = config;
    }

    public async load(name: string, url: string): Promise<void> {
        if (this.sounds[name]) {
            console.warn(`Sound "${name}" readly exists.`);
            return;
        }
        const sound = new Sound(name, this.name, this.config);
        await sound.load(url);
        this.sounds[name] = sound;
    }

    public async play(name: string, crossFade: boolean = true, volume: number = 1): Promise<void> {
        const sound = this.sounds[name];
        if (!sound) {
            console.error(`Sound "${name}" in slot "${this.name}" does not exist.`);
            return;
        }
        const buffer = await sound.getBuffer();
        const stopTime = this.stop();
        const nodes = new SlotNodes(buffer, this.context);
        nodes.source.loop = this.loop;
        nodes.source.onended = () => {
            console.log(nodes)
            if (this.nodes === nodes) {
                this.nodes = null;
            }
            this.nodesSet.delete(nodes);
            nodes.source.stop();
            nodes.source.disconnect();
            nodes.gain.disconnect();
        };
        const gain = nodes.gain;

        let fadeDone;
        let startTime;
        if (crossFade) {
            startTime = this.context.currentTime;
        } else {
            startTime = stopTime;
        }
        if (this.loop) {
            fadeDone = startTime + this.config.fadeTime;
        } else {
            fadeDone = startTime + 0.01;
        }
        gain.gain.setValueAtTime(0, startTime);
        gain.gain.linearRampToValueAtTime(volume, fadeDone);
        this.volume = volume;
        if (this.nodes) {
            this.nodesSet.delete(this.nodes);
        }
        nodes.source.start(startTime);
        this.nodesSet.add(nodes);
        this.nodes = nodes;
    }

    public stop(): number {
        const time = this.context.currentTime;
        if (!this.nodes) {
            return time;
        }
        const gain = this.nodes.gain;
        let stopAt;
        if (this.loop) {
            stopAt = time + this.config.fadeTime;
        } else {
            stopAt = time + 0.02;
        }
        gain.gain.setValueAtTime(this.volume, time);
        gain.gain.linearRampToValueAtTime(0, stopAt);
        this.nodes.source.stop(stopAt);
        return stopAt;
    }

    public stopAll(): void {
        for (const nodes of Object.values(this.nodesSet)) {
            nodes.gain.gain.value = 0;
            nodes.source.stop();
            nodes.source.disconnect();
            nodes.gain.disconnect();
            console.log(nodes)
        }
        this.nodesSet.clear();
        this.nodes = null;
    }
}

class Group {
    readonly name: string;
    private config: Config;
    private slots: Slot[] = [];

    constructor(name: string, config: Config) {
        this.name = name;
        this.config = config;
    }

    public addSlot(slot: Slot): void {
        this.slots.push(slot);
    }

    public async stop(): Promise<void> {
        this.slots.forEach(slot => slot.stop());
    }
}

class Mixer {
    private config: Config;;
    private context: AudioContext;
    private slots: Slots = {};
    private groups: Groups = {};
    private dummy: AudioBufferSourceNode | null = null;

    constructor() {
        const context = new window.AudioContext({ sampleRate: 44100 });
        this.context = context
        this.config = new Config(this.context);
        //this.startDummy();
        window.addEventListener('beforeunload', (event) => {
            for (const slot of Object.values(this.slots)) {
                slot.stopAll();
            }
        });
    }

    private startDummy(): void {
        const context = this.context;
        const dummy = context.createBuffer(2, 1, context.sampleRate);
        this.dummy = context.createBufferSource();
        this.dummy.loop = true;
        this.dummy.buffer = dummy;
        this.dummy.connect(context.destination);
        this.dummy.start(context.currentTime);
    }

    public async load(slotName: string, soundName: string, url: string): Promise<void> {
        const slot = this.slots[slotName];
        if (!slot) {
            console.error(`Slot "${slotName}" does not exist, please create it first.`);
            return;
        }
        await slot.load(soundName, url);
    }

    public async play(slotName: string, soundName: string): Promise<void> {
        const slot = this.slots[slotName];
        if (!slot) {
            console.error(`Slot "${slotName}" does not exist, please create it first.`);
            return;
        } else {
            await slot.play(soundName);
        }
    }

    public async stop(slotName: string): Promise<void> {
        const slot = this.slots[slotName];
        if (!slot) {
            console.error(`Slot "${slotName}" does not exist, please create it first.`);
            return;
        } else {
            await slot.stop();
        }
    }

    public async stopGroup(groupName: string): Promise<void> {
        const group = this.groups[groupName];
        if (!group) {
            console.error(`Slot "${groupName}" does not exist, please create it first.`);
            return;
        } else {
            await group.stop();
        }
    }

    public setFadeTime(time: number): void {
        this.config.fadeTime = time
    }

    public async sleep(time: number): Promise<void> {
        await sleep(time);
    }

    public createSlot(name: string, loop: boolean = false, groupList: string[] = []): void {
        const slot = new Slot(name, loop, this.config);
        this.slots[name] = slot;
        groupList.forEach((groupName) => {
            this.addSlotToGroup(groupName, slot);
        });
        this.addSlotToGroup("all", slot);
    }

    private addSlotToGroup(name: string, slot: Slot): void {
        let group = this.groups[name];
        if (!group) {
            group = new Group(name, this.config);
        }
        group.addSlot(slot);
    }
}

export { Mixer };
