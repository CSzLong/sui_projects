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

        
    #[test]
    
    public fun test_balance(){
        use std::debug;
        use sui::coin;

        let bal = coin::balance<GOAL>(0x2d91fb31e234d7de81de597c7356c907ddd70d90);
        debug::print(bal);
    }
}