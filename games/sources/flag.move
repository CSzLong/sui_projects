module games::flag {
    use std::ascii::into_bytes;
    use std::string::{Self, String};
    use std::type_name::{get, into_string};

    use sui::object::{Self, UID, ID};
    use sui::table::{Self, Table};
    use sui::transfer;
    use sui::tx_context::TxContext;

    friend games::play;

    struct Flag has key {
        id: UID,
        coin: Table<String, ID>
    }

    fun init(ctx: &mut TxContext) {
        let coin = table::new<String, ID>(ctx);
        let flag = Flag {
            id: object::new(ctx),
            coin,
        };
        transfer::share_object(flag);
    }

    public(friend) fun add<Coin>(flag: &mut Flag, id: ID) {
        table::add(&mut flag.coin, get_name<Coin>(), id);
    }

    public(friend) fun exists_coin<Coin>(flag: &mut Flag): bool {
        table::contains(&flag.coin, get_name<Coin>())
    }

    public fun get_name<Coin>(): String {
        let name = get<Coin>();
        let str = string::utf8(b"");
        string::append_utf8(&mut str, into_bytes(into_string(name)));
        str
    }
}