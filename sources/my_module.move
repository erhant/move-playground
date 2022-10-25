module playground::my_module {
    // Part 1: imports
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    // Part 2: struct definitions
    struct Sword has key, store {
        id: UID,
        magic: u64,
        strength: u64,
    }

    struct Forge has key, store {
        id: UID,
        swords_created: u64,
    }

    // Part 3: module initializer to be executed when this module is published
    fun init(ctx: &mut TxContext) {
        let admin = Forge {
            id: object::new(ctx),
            swords_created: 0,
        };
        // transfer the forge object to the module/package publisher
        transfer::transfer<Forge>(admin, tx_context::sender(ctx));
    }

    // Part 4: accessors required to read the struct attributes
    public fun magic(self: &Sword): u64 {
        self.magic
    }

    public fun strength(self: &Sword): u64 {
        self.strength
    }

    public fun swords_created(self: &Forge): u64 {
        self.swords_created
    }

    #[test]
    public fun test_sword_create() {
        use sui::tx_context;
        use sui::transfer;

        // create a dummy TxContext for testing
        let ctx = tx_context::dummy();

        // create a sword
        let magic = 42;
        let strength = 7;
        let sword = Sword {
            id: object::new(&mut ctx),
            magic: magic,
            strength: strength,
        };

        // check if accessor functions return correct values
        assert!(magic(&sword) == magic && strength(&sword) == strength, 1);

        // create a dummy address and transfer the sword
        transfer::transfer<Sword>(sword, @dummy);
    }

    // part 5: public / entry functions
    public entry fun sword_create(magic: u64, strength: u64, recipient: address, ctx: &mut TxContext) {
        use sui::transfer;

        // create a sword
        let sword = Sword {
            id: object::new(ctx),
            magic: magic,
            strength: strength,
        };
        // transfer the sword
        transfer::transfer(sword, recipient);
    }

    public entry fun sword_transfer(sword: Sword, recipient: address, _ctx: &mut TxContext) {
        use sui::transfer;
        // transfer the sword
        transfer::transfer(sword, recipient);
    }

    #[test]
    fun test_sword_transactions() {
        use sui::test_scenario;

        let admin = @0xABBA;
        let initial_owner = @0xCAFE;
        let final_owner = @0xFACE;

        // first transaction executed by admin
        let scenario = &mut test_scenario::begin(admin);
        {
            // create the sword and transfer it to the initial owner
            sword_create(42, 7, initial_owner, test_scenario::ctx(scenario));
        };
        // second transaction executed by the initial sword owner
        test_scenario::next_tx(scenario, initial_owner);
        {
            // extract the sword owned by the initial owner
            let sword = test_scenario::take_from_address<Sword>(scenario, initial_owner);
            // transfer the sword to the final owner
            sword_transfer(sword, final_owner, test_scenario::ctx(scenario));
        };
        // third transaction executed by the final sword owner
        test_scenario::next_tx(scenario, final_owner);
        {
            // extract the sword owned by the final owner
            let sword = test_scenario::take_from_address<Sword>(scenario, final_owner);
            // verify that the sword has expected properties
            assert!(magic(&sword) == 42 && strength(&sword) == 7, 1);
            // return the sword to the object pool (it cannot be simply "dropped")
            test_scenario::return_to_sender(scenario, sword);
            
        }
    }

    // part 6: private functions (if any)
}