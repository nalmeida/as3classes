function find_in_library(find_string){
	var items = fl.getDocumentDOM().library.items;
	// first get the full name
	for( var i = 0, len = items.length; i < len; i++){
		if(items[i].name === find_string){
			return items[i];
		}
	}
	// if nothing is found look only for the symbol name
	for( var i = 0, len = items.length; i < len; i++){
		if(items[i].name.replace(/.*\//, "") === find_string){
			return items[i];
		}
	}
}

var timeline = fl.getDocumentDOM().getTimeline();
var layer = timeline.layers[timeline.getSelectedLayers()];
var frames = layer.frames;
var newName = prompt("Fazer o Swap Instance para o layer \""+layer.name+"\"?");
var foundSymbol = find_in_library(newName);


if(newName != null && foundSymbol){
	for(var j=0; j<frames.length; j++){
		if(frames[j].elements.length > 0){
			frames[j].elements[0].libraryItem = foundSymbol;
		}
	}
}