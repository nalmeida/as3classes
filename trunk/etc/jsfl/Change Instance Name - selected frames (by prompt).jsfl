var timeline = fl.getDocumentDOM().getTimeline();
var frames = timeline.getSelectedFrames();
var framesToEdit = [];
var eachLayer;

var newName = prompt("Digite o nome para a instância dos frames selecionados.");

if(newName != null){

	for(var i=0; i<frames.length; (i = i+3)){
		framesToEdit.push({
			layer: frames[i],
			frameIni: frames[i+1],
			frameEnd: frames[i+2]
		});
	}

	for(var i=0; i<framesToEdit.length; i++){
		eachLayer = timeline.layers[framesToEdit[i].layer].frames;
		for(var j=framesToEdit[i].frameIni; j<framesToEdit[i].frameEnd; j++){
			if(eachLayer[j].elements.length > 0){
				// fl.trace("changed name of "+eachLayer[j].elements[0]+" to "+newName);
				eachLayer[j].elements[0].name = newName;
			}
		}
	}
}
/*
var newName = prompt("Nome para a instância dos elementos nos frames selecionados \""+layer.name+"\"");

if(newName != null){
	for(var j=0; j<frames.length; j++){
		if(frames[j].elements.length > 0){
			fl.trace("changed name of "+frames[j].elements[0]+" to "+newName);
			frames[j].elements[0].name = newName;
		}
	}
}
*/