var timeline = fl.getDocumentDOM().getTimeline();
var layers = timeline.layers;
var frames = null;

if(confirm("Deseja prosseguir com a mudança do instance name de todos os layers?") == true){
	for(var j=0; j<layers.length; j++){
		// fl.trace("layers["+j+"]: "+layers[j]);
		frames = layers[j].frames;
		for(var h=0; h<frames.length; h++){
			frames[h].elements[0].name = layers[j].name;
		}
	}
}