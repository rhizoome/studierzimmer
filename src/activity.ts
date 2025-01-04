class Activity {
    private current: number = 0;
    private count: number = 0;
    private resolution: number = 10;

    constructor(resolution: number = 10) {
        this.resolution = resolution;
        ['visibilitychange', 'click', 'keydown', 'scroll', 'touchstart'].forEach(event => {
            window.addEventListener(event, this.track.bind(this));
        });
    }

    public reset(): void {
        this.count = 0;
    }

    public activity(): number {
        return this.count * this.resolution;
    }

    public track(): void {
        const ts = this.ts();
        if (this.current != ts) {
            this.count += 1;
            this.current = ts;
        }
    }

    private ts(): number {
        return Math.floor(Date.now() / 1000 / this.resolution);
    }
}

export { Activity }
