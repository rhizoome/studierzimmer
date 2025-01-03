class DefaultDict<K, V> extends Map<K, V> {
    constructor(private defaultFactory: () => V) {
        super();
    }

    get(key: K): V {
        if (!this.has(key)) {
            this.set(key, this.defaultFactory());
        }
        return super.get(key)!;
    }
}

function sleep(time: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, time * 1000));
}

export { DefaultDict, sleep };
