module playground::SwordForge { 
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
 
    struct Sword has key, store {
        id: UID,
        magic: u64,
        strength: u64,
    }

    struct Forge has key, store {
        id: UID,
        swords_created: u64,
    }
 
    fun init(ctx: &mut TxContext) {
        let admins_forge = Forge {
            id: object::new(ctx),
            swords_created: 0,
        };
        transfer::transfer<Forge>(admins_forge, tx_context::sender(ctx));
    }
 
    public fun get_magic(self: &Sword): u64 {
        self.magic
    }

    public fun get_strength(self: &Sword): u64 {
        self.strength
    }

    public fun get_swords_created(self: &Forge): u64 {
        self.swords_created
    } 
    
    /// Create a sword object for a recipient using a given forge.
    public entry fun create_sword(forge: &mut Forge, magic: u64, strength: u64, recipient: address, ctx: &mut TxContext) {
        let sword = Sword {
            id: object::new(ctx),
            magic: magic,
            strength: strength,
        };
        transfer::transfer<Sword>(sword, recipient);
        forge.swords_created = forge.swords_created + 1;
    }

    /// Transfers a given sword to a recipient.
    public entry fun transfer_sword(sword: Sword, recipient: address, _ctx: &mut TxContext) {
        transfer::transfer<Sword>(sword, recipient);
    }
    
    #[test]
    fun test_sword_create() {
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
        assert!(get_magic(&sword) == magic && get_strength(&sword) == strength, 1);

        // create a dummy address and transfer the sword
        transfer::transfer<Sword>(sword, @dummy);
    }
    
    #[test]
    fun test_sword_transactions() {
        use sui::test_scenario;

        // create test addresses representing users
        let admin = @0xBABE;
        let initial_owner = @0xCAFE;
        let final_owner = @0xFACE;

        // begin a scenario
        let scenario_val = test_scenario::begin(admin);

        // first transaction to emulate module initialization
        let scenario = &mut scenario_val; {
            init(test_scenario::ctx(scenario));
        };

        // second transaction executed by admin to create the sword
        test_scenario::next_tx(scenario, admin); {
            let forge = test_scenario::take_from_sender<Forge>(scenario);
            create_sword(&mut forge, 42, 7, initial_owner, test_scenario::ctx(scenario));
            test_scenario::return_to_sender(scenario, forge)
        };

        // third transaction executed by the initial sword owner
        test_scenario::next_tx(scenario, initial_owner); {
            let sword = test_scenario::take_from_sender<Sword>(scenario);
            transfer::transfer(sword, final_owner);
        };

        // fourth transaction executed by the final sword owner
        test_scenario::next_tx(scenario, final_owner); {
            let sword = test_scenario::take_from_sender<Sword>(scenario);
            assert!(get_magic(&sword) == 42 && get_strength(&sword) == 7, 1);
            test_scenario::return_to_sender(scenario, sword);
        };

        // finish scenario
        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_module_init() {
        use sui::test_scenario;

        // create test address representing game admin
        let admin = @0xBABE;

        // first transaction to emulate module initialization
        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;
        {
            init(test_scenario::ctx(scenario));
        };

        // second transaction to check if the forge has been created
        // and has initial value of zero swords created
        test_scenario::next_tx(scenario, admin);
        {
            let forge = test_scenario::take_from_sender<Forge>(scenario);
            assert!(get_swords_created(&forge) == 0, 1);
            test_scenario::return_to_sender(scenario, forge);
        };
        test_scenario::end(scenario_val);
    }
}