module scores::score {
    use sui::coin::{Self, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{TxContext, sender};
    
    struct SCORE has drop {}
    
    fun init(witness: SCORE, ctx: &mut TxContext) {
        transfer::transfer(coin::create_currency(
            witness, 9, ctx), sender(ctx));
    }
    
    public entry fun mint_me(cap: &mut  TreasuryCap<SCORE>, amount: u64, ctx: &mut TxContext) {
        let coin_usdt = coin::mint(cap, amount, ctx);
        transfer::transfer(coin_usdt, sender(ctx));
    }

    public entry fun mint_to(cap: &mut  TreasuryCap<SCORE>, amount: u64, to: address, ctx: &mut TxContext) {
        let coin_usdt = coin::mint(cap, amount, ctx);
        transfer::transfer(coin_usdt, to);
    }
}