module MyModule::Tipping {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct to store the total tips received by a creator.
    struct CreatorTips has store, key {
        total_tips: u64,
    }

    /// Function to initialize a creator's tipping account.
    public fun init_creator(creator: &signer) {
        let tips = CreatorTips {
            total_tips: 0,
        };
        move_to(creator, tips);
    }

    /// Function for fans to send tips to a creator.
    public fun send_tip(fan: &signer, creator_addr: address, amount: u64) acquires CreatorTips {
        let tips = borrow_global_mut<CreatorTips>(creator_addr);

        // Withdraw tip amount from the fan's account
        let tip = coin::withdraw<AptosCoin>(fan, amount);

        // Deposit the tip to the creator's account
        coin::deposit<AptosCoin>(creator_addr, tip);

        // Update total tips received
        tips.total_tips = tips.total_tips + amount;
    }
}
