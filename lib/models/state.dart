class StateList {
  List<StatesList> states;
  int ttl;

  StateList({this.states, this.ttl});

  StateList.fromMap(Map<String, dynamic> json) {
    if (json['states'] != null) {
      states = [];
      json['states'].forEach((v) {
        states.add(new StatesList.fromMap(v));
      });
    }
    ttl = json['ttl'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.states != null) {
      data['states'] = this.states.map((v) => v.toMap()).toList();
    }
    // data['ttl'] = this.ttl;
    return data;
  }
}

class StatesList {
  int stateId;
  String stateName;

  StatesList({this.stateId, this.stateName});

  StatesList.fromMap(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    return data;
  }
}
