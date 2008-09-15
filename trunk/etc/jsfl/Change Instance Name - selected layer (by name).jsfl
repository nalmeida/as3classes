var timeline = fl.getDocumentDOM().getTimeline();
var layer = timeline.layers[timeline.getSelectedLayers()];
var frames = layer.frames;

if(confirm("Deseja prosseguir com a mudança do instance name dos elementos para o nome do layer \""+layer.name+"\"") == true){
	for(var j=0; j<frames.length; j++){
		if(frames[j].elements.length > 0){
			// fl.trace("changed name of "+frames[j].elements[0]+" to "+layer.name);
			frames[j].elements[0].name = layer.name;
		}
	}
}