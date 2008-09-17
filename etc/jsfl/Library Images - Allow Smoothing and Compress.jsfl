function init(){
	fl.outputPanel.clear();
	var newQuality = prompt("Nova qualidade para todas as imagens.");
	var item_array = fl.getDocumentDOM().library.items;
	var i = item_array.length;
	while(i--){
		var item = item_array[i];
		if(item.itemType == "bitmap"){
			item.allowSmoothing = true;
			item.compressionType = "photo";
			item.useImportedJPEGQuality = true;
			item.quality = newQuality;
		}
	}
}

// start this mug
init();