function init()
{
	fl.outputPanel.clear();
	var item_array = fl.getDocumentDOM().library.items;
	var i = item_array.length;
	while(i--)
	{
		var item = item_array[i];
		if(item.itemType == "bitmap")
		{
			item.allowSmoothing = true;
		}
	}
	fl.trace("Command successful. All Bitmaps on library changed to Allow Smoothing.");
}

// start this mug
init();