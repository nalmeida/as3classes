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
			item.compressionType = "photo";
			item.useImportedJPEGQuality = true;
			fl.trace(item.name + " useImportedJPEGQuality is now false, and compressionType is now lossless.\n");
		}
	}
}

// start this mug
init();