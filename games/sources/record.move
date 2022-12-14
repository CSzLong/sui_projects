module games::record {

    use sui::transfer;
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{TxContext, sender};

    const ErrOverflow: u64 = 1001;
    const ErrNotEnough: u64 = 1002;

    struct Record has key, store {
        id: UID,
        score: u64
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(
            Record {
                id: object::new(ctx),
                score: 0
            },
            sender(ctx)
        )
    }

    public fun create(ctx: &mut TxContext): ID {
        let record = Record {
            id: object::new(ctx),
            score: 0
        };
        let record_id = object::id(&record);
        transfer::transfer(
            record,
            sender(ctx)
        );
        record_id
    }

    public fun increase_score(self: &mut Record, value: u64) {
        self.score = self.score + value;
    }

    public fun decrease_score(self: &mut Record, value: u64) {
        assert!(self.score < value, ErrNotEnough);
        self.score = self.score - value;
    }

    spec split {
        aborts_if self.value < value with ErrNotEnough;
        ensures self.value == old(self.value) - value;
    }
}