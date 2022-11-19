module games::goal{
    use sui::coin::{Self, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{TxContext, sender};
    
    struct GOAL has drop {}
    
    fun init(witness: GOAL, ctx: &mut TxContext) {
        transfer::share_object(coin::create_currency(
            witness, 9, ctx));
    }
    
    public entry fun mint_me(cap: &mut  TreasuryCap<GOAL>, amount: u64, ctx: &mut TxContext) {
        transfer::transfer(coin::mint(cap, amount, ctx), sender(ctx));
    }
    
    public entry fun mint_to(cap: &mut  TreasuryCap<GOAL>, amount: u64, to: address, ctx: &mut TxContext) {
        transfer::transfer(coin::mint(cap, amount, ctx), to);
    }
}