module game_balances::gamebalance{
    use sui::transfer;
    use sui::coin::{Self, TreasuryCap};
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use sui::tx_context::{TxContext, sender};
    use game_balances::bal::{BAL};

    struct Gamebalance has key, store{
        id: UID,
        gamer: address,
        balance: Balance<BAL>
    }
    
    fun init(ctx: &mut TxContext){
        transfer::transfer(Gamebalance{
                            id: object::new(ctx),
                            gamer: sender(ctx),
                            balance: balance::zero<BAL>()
                            },
                           sender(ctx)
        )
    }
    
    public entry fun create_and_transfer(cap: &mut TreasuryCap<BAL>, amount: u64, addr: address, ctx: &mut TxContext){
        
        
        let balance = coin::into_balance<BAL>(coin::mint(cap, amount, ctx));
        
        transfer::transfer(Gamebalance{
                            id: object::new(ctx),
                            gamer: addr,
                            balance: balance
                            },
                          addr)
    }
}