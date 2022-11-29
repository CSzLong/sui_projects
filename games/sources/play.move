module games::play {
    use games::flag::{Self, Flag};
    use games::gcoin::{Self, GCOIN};
    use games::record::{Self, Record};

    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::sui::SUI;
    use sui::tx_context::{TxContext, sender};
    use sui::transfer::{Self, transfer};
    use sui::balance;
    use sui::object;

    const ErrCoin_Exist: u64 = 1003;
    const ErrNot_Enough_Coin: u64 = 1004;
    const GAMEADDR :address = @0x7497bdeec1916b3fd1e8660290e98c3cf671d607;

    public entry fun init_coin(flag: &mut Flag,
                               ctx: &mut TxContext){
        assert!(!flag::exists_coin<GCOIN>(flag), ErrCoin_Exist);
        let zero_coin = coin::zero<GCOIN>(ctx);
        let coin_id = object::id(&zero_coin);
        //let coin_id = gcoin::mint_to_me(cap, 0, ctx);
        transfer(zero_coin, sender(ctx));
        flag::add<GCOIN>(flag, coin_id);
    }

    public entry fun init_record(ctx: &mut TxContext){
        record::create(ctx);
    }

    public entry fun increase_score(record: &mut Record, value: u64){
        record::increase_score(record, value);
    }

    public entry fun decrease_score(record: &mut Record, value: u64){
        record::decrease_score(record, value);
    }

    public entry fun buy_coin(coin: &mut Coin<GCOIN>,
                              payment: &mut Coin<SUI>,
                              amount: u64,
                              cap: &mut TreasuryCap<GCOIN>,
                              ctx: &mut TxContext) {
        let coin_balance = coin::balance_mut(payment);
        assert!(balance::value(coin_balance) < amount, ErrNot_Enough_Coin);
        let paid_coin = balance::split(coin_balance, amount);
        transfer::transfer(coin::from_balance<SUI>(paid_coin, ctx), GAMEADDR);
        coin::join(coin, coin::mint(cap, amount, ctx));
    }

    public entry fun pay_coin(
        coin: &mut Coin<GCOIN>,
        cap: &mut TreasuryCap<GCOIN>,
        value: u64,
        ctx: &mut TxContext){
        gcoin::pay_coin(coin, cap, value, ctx);
    }

    public entry fun gain_coin(
        coin: &mut Coin<GCOIN>,
        cap: &mut TreasuryCap<GCOIN>,
        value: u64,
        ctx: &mut TxContext){
        gcoin::join_coin(coin, cap, value, ctx);
    }
}