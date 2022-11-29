module game_balances::gamebalance{
    use sui::transfer;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use sui::tx_context::{TxContext, sender};
    use game_balances::bal::{BAL};
    
    struct Gamebalance has key, store{
        id: UID,
        gamer: address,
        balance: Balance<BAL>
    }

    const EAMOUNT_NOT_MATCH :u64 = 10;
    
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
        
        transfer::transfer(coin::mint(cap, amount, ctx), addr);
           
        assert!(balance::value(&balance) == amount, EAMOUNT_NOT_MATCH);
        
        transfer::transfer(Gamebalance{
                            id: object::new(ctx),
                            gamer: addr,
                            balance: balance
                            },
                          addr)
    }
    
    public entry fun update_bal(gb: &mut Gamebalance, coin: &mut Coin<BAL>, value: u64, to: address, ctx: &mut TxContext){
  
        let coin_bal = coin::balance_mut<BAL>(coin);
        
        let paid_bal = balance::split(coin_bal, value);
        
        transfer::transfer(coin::from_balance(paid_bal, ctx), to);
        
        let rest_bal = balance::split<BAL>(&mut gb.balance, value);
        
        transfer::transfer(Gamebalance{
                            id: object::new(ctx),
                            gamer: sender(ctx),
                            balance: rest_bal
                            },
                          sender(ctx))
    }

    public entry fun update_bal_other(gb: &mut Gamebalance, value: u64, ctx: &mut TxContext){
        
        let rest_bal = balance::split<BAL>(&mut gb.balance, value);
        
        transfer::transfer(Gamebalance{
                            id: object::new(ctx),
                            gamer: sender(ctx),
                            balance: rest_bal
                            },
                          sender(ctx))
    }
}