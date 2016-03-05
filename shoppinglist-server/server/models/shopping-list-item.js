module.exports = function(ShoppingListItem) {
	ShoppingListItem.observe('before save', function updateTimestamp(ctx, next) {
	  if (ctx.instance) {
	    ctx.instance.timestamp = (new Date).getTime();
	  } else {
	    ctx.data.timestamp = (new Date).getTime();
	  }
	  next();
	});
}