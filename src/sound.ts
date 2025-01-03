type Slots = Record<string, Slot>;
type Groups = Record<string, Group>;
type Sounds = Record<string, Sound>;

class Config {
    public fadeTime: number = 0.5;
    public context: AudioContext;
    constructor(context: AudioContext) {
        this.context = context;
    }
}

class SlotNodes {
    private context: AudioContext;
    private config: Config;
    private source: AudioBufferSourceNode;
    private gain: GainNode;

    constructor(config: Config) {
        this.context = config.context;
        this.config = config;
        this.source = this.context.createBufferSource();
        this.gain = this.context.createGain();
        this.source.connect(this.gain).connect(this.context.destination);
    }
}

class Sound {
    readonly name: string;
    private buffer: ArrayBuffer | null = null;
    private context: AudioContext;
    private config: Config;

    constructor(name: string, config: Config) {
        this.name = name;
        this.context = config.context;
        this.config = config;
    }

    public async load(url: string): Promise<void> {
        try {
            const response = await fetch(url);
            this.buffer = await response.arrayBuffer();
        } catch (error) {
            console.error(`Failed to load sound "${this.name}" from "${url}"`, error);
        }
    }

    public async getBuffer(): Promise<AudioBuffer> {
        if (this.buffer) {
            try {
                return await this.context.decodeAudioData(this.buffer);
            } catch (error) {
                console.error(`Failed to decode audio data of "${this.name}"`, error);
            }
        }
        return this.context.createBuffer(2, 1, this.context.sampleRate);
    }
}

class Slot {
    readonly name: string;
    private context: AudioContext;
    private config: Config;
    private active: SlotNodes;
    private passive: SlotNodes;
    private sounds: Sounds = {};

    constructor(name: string, config: Config) {
        this.name = name;
        this.context = config.context;
        this.config = config;
        this.active = new SlotNodes(this.config);
        this.passive = new SlotNodes(this.config);
    }

    public async load(name: string, url: string): Promise<void> {
        if (this.sounds[name]) {
            console.warn(`Sound "${name}" readly exists.`);
            return;
        }
        const sound = new Sound(name, this.config);
        await sound.load(url);
        this.sounds[name] = sound;
    }

    public play(name: string): void {
    }

    public stop(): void {
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
}

class Mixer {
    private config: Config;;
    private context: AudioContext;
    private slots: Slots = {};
    private groups: Groups = {};
    private sounds: Slots = {};

    constructor() {
        this.context = new window.AudioContext();
        this.config = new Config(this.context);
    }

    public async load(slotName: string, soundName: string, url: string): Promise<void> {
        const slot = this.slots[slotName];
        if (!slot) {
            console.error(`Slot "${slotName}" does not exist, please create it first`);
            return;
        }
        await slot.load(soundName, url);
    }

    public setFadeTime(time: number): void {
        this.config.fadeTime = time
    }

    public createSlot(name: string, groupList: string[]): void {
        const slot = new Slot(name, this.config);
        this.slots[name] = slot;
        groupList.forEach((groupName) => {
            this.addSlotToGroup(groupName, slot);
        });
    }

    private addSlotToGroup(name: string, slot: Slot): void {
        let group = this.groups[name];
        if (!group) {
            group = new Group(name, this.config);
        }
        group.addSlot(slot);
    }
}

