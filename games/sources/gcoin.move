module games::gcoin {

    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::object::{Self, ID};
    use sui::transfer;
    use sui::tx_context::{TxContext, sender};

    struct GCOIN has drop {}

    const DECIMALS: u8 = 9;
    const ErrNot_Enough_Balance: u64 = 1002;

    friend games::record;

    fun init(witness: GCOIN, ctx: &mut TxContext) {
        transfer::share_object(coin::create_currency(
            witness, DECIMALS, ctx));
    }

    public fun mint_to_me(cap: &mut TreasuryCap<GCOIN>, amount: u64, ctx: &mut TxContext): ID {
        let coin = coin::mint(cap, amount, ctx);
        let id = object::id(&coin);
        transfer::transfer(coin, sender(ctx));
        id
    }

    public fun pay_coin(
        self: &mut Coin<GCOIN>,
        cap: &mut TreasuryCap<GCOIN>,
        value: u64,
        ctx: &mut TxContext
    ) {
        assert!(coin::value<GCOIN>(self) >= value, ErrNot_Enough_Balance);
        let coin_paid = coin::split<GCOIN>(self, value, ctx);
        coin::burn<GCOIN>(cap, coin_paid);
    }

    public fun join_coin(
        coin: &mut Coin<GCOIN>,
        cap: &mut TreasuryCap<GCOIN>,
        value: u64,
        ctx: &mut TxContext
    ) {
        let mint_coin = coin::mint(cap, value, ctx);
        coin::join(coin, mint_coin);
    }
}