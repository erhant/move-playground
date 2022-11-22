module owner::collatz_lengths {
  use std::Vector;

  struct Item has store {}

  struct Collection has key {
    items: vector<Item>
  }

  /// note that &signer type is passed here!
  public fun start_collection(account: &signer) {
    move_to<Collection>(account, Collection {
      items: Vector::empty<Item>()
    })
  }
}