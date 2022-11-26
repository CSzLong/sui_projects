module tokens::token{
    use sui::coin::{Self, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{TxContext, sender};
    
    struct TOKEN has drop {}
    
    const DECIMALS :u8 = 9;
    
    fun init(witness: TOKEN, ctx: &mut TxContext) {
        let cap = coin::create_currency(witness, DECIMALS, ctx);
        transfer::transfer(cap, sender(ctx));
    }
    
    public entry fun mint_me(cap: &mut TreasuryCap<TOKEN>, amount: u64, ctx: &mut TxContext) {
        transfer::transfer(coin::mint(cap, amount, ctx), sender(ctx));
    }
    
    public entry fun mint_to(cap: &mut TreasuryCap<TOKEN>, amount: u64, to: address, ctx: &mut TxContext) {
        transfer::transfer(coin::mint(cap, amount, ctx), to);
    }
}