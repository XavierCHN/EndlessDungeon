function WrapFunction(name) {
    return function() {
        Game[name]();
    };
}

(function() {
	Game.AddCommand( "+PlayerMoveUp", WrapFunction("PlayerMoveUp"), "", 0 );
	Game.AddCommand( "+PlayerMoveDown", WrapFunction("PlayerMoveDown"), "", 0 );
	Game.AddCommand( "+PlayerMoveLeft", WrapFunction("PlayerMoveLeft"), "", 0 );
	Game.AddCommand( "+PlayerMoveRight", WrapFunction("PlayerMoveRight"), "", 0 );
	Game.AddCommand( "-PlayerMoveUp", WrapFunction("PlayerMoveUp_End"), "", 0 );
	Game.AddCommand( "-PlayerMoveDown", WrapFunction("PlayerMoveDown_End"), "", 0 );
	Game.AddCommand( "-PlayerMoveLeft", WrapFunction("PlayerMoveLeft_End"), "", 0 );
	Game.AddCommand( "-PlayerMoveRight", WrapFunction("PlayerMoveRight_End"), "", 0 );

	Game.AddCommand( "+PlayerDash", WrapFunction("PlayerDash"), "", 0);
	Game.AddCommand( "+PlayerExecute1", WrapFunction("PlayerExecute1"), "", 0);
	Game.AddCommand( "+PlayerExecute2", WrapFunction("PlayerExecute2"), "", 0);
	Game.AddCommand( "-PlayerDash", WrapFunction("EmptyCallback"), "", 0);
	Game.AddCommand( "-PlayerExecute1", WrapFunction("EmptyCallback"), "", 0);
	Game.AddCommand( "-PlayerExecute2", WrapFunction("EmptyCallback"), "", 0);
	Game.AddCommand( "+PlayerPickUp", WrapFunction("PlayerPickUp"), "", 0);
    Game.AddCommand( "-PlayerPickUp", WrapFunction("EmptyCallback"), "", 0);

    // 此处我们暂时不适用方向键射击了，还是需要释放出玩家的鼠标，让玩家用熟悉的方式操作
    // Game.AddCommand( "+PlayerShootUp", WrapFunction("PlayerStartShootUp"), "", 0);
    // Game.AddCommand( "+PlayerShootDown", WrapFunction("PlayerStartShootDown"), "", 0);
    // Game.AddCommand( "+PlayerShootLeft", WrapFunction("PlayerStartShootLeft"), "", 0);
    // Game.AddCommand( "+PlayerShootRight", WrapFunction("PlayerStartShootRight"), "", 0);
    // Game.AddCommand( "-PlayerShootUp", WrapFunction("PlayerEndShootUp"), "", 0);
    // Game.AddCommand( "-PlayerShootDown", WrapFunction("PlayerEndShootDown"), "", 0);
    // Game.AddCommand( "-PlayerShootLeft", WrapFunction("PlayerEndShootLeft"), "", 0);
    // Game.AddCommand( "-PlayerShootRight", WrapFunction("PlayerEndShootRight"), "", 0);
})();
