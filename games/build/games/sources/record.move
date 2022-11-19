module games::record{

    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{TxContext, sender};

    struct Record has key, store{
        id: UID,
        gamer: address,
        score: u64
    }
    
    fun init(ctx: &mut TxContext){
        
        transfer::transfer(
            Record{
                id: object::new(ctx),
                gamer: sender(ctx),
                score: 0
            },
            sender(ctx)
        )
    }
    
    public entry fun create_and_transfer(score: u64, addr: address, ctx: &mut TxContext){

        transfer::transfer(
            Record{
                id: object::new(ctx),
                gamer: addr,
                score: score
            },
            addr
        )
    }

}