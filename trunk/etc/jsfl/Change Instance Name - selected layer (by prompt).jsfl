var timeline = fl.getDocumentDOM().getTimeline();
var layer = timeline.layers[timeline.getSelectedLayers()];
var frames = layer.frames;
var newName = prompt("Nome para a instância do layer \""+layer.name+"\"");

if(newName != null){
	for(var j=0; j<frames.length; j++){
		if(frames[j].elements.length > 0){
			// fl.trace("changed name of "+frames[j].elements[0]+" to "+newName);
			frames[j].elements[0].name = newName;
		}
	}
}