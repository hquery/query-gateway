var queryStructure = queryStructure || {};
var __hasProp = Object.prototype.hasOwnProperty, __extends = function (child, parent) {
    for (var key in parent) {
        if (__hasProp.call(parent, key)) child[key] = parent[key];
    }
    function ctor() {
        this.constructor = child;
    }

    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
};
this.queryStructure || (this.queryStructure = {});
queryStructure.Query = (function () {
    function Query() {
        this.find = new queryStructure.And(null);
        this.filter = new queryStructure.And(null);
        this.extract = new queryStructure.Extraction([], []);
    }

    Query.prototype.toJson = function () {
        return {      'find': this.find.toJson(), 'filter': this.filter.toJson(), 'extract': this.extract.toJson()    };
    };
    Query.prototype.rebuildFromJson = function (json) {
        this.find = json['find'] ? this.buildFromJson(null, json['find']) : new queryStructure.And(null);
        this.filter = json['filter'] ? this.buildFromJson(null, json['filter']) : new queryStructure.And(null);
        return this.extract = json['extract'] ? queryStructure.Extraction.rebuildFromJson(json['extract']) : new queryStructure.Extraction([], []);
    };
    Query.prototype.buildFromJson = function (parent, element) {
        var child, container, newContainer, ruleType, _i, _len, _ref;
        if (this.getElementType(element) === 'rule') {
            ruleType = element.type;
            return new queryStructure[ruleType](element.data);
        } else {
            container = this.getContainerType(element);
            newContainer = new queryStructure[container](parent, [], element.name, element.title, element.negate);
            _ref = element[container.toLowerCase()];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                child = _ref[_i];
                newContainer.add(this.buildFromJson(newContainer, child));
            }
            return newContainer;
        }
    };
    Query.prototype.getElementType = function (element) {
        if ((element['and'] != null) || (element['or'] != null)) {
            return 'container';
        } else {
            return 'rule';
        }
    };
    Query.prototype.getContainerType = function (element) {
        if (element['and'] != null) {
            return 'And';
        } else if (element['or'] != null) {
            return 'Or';
        } else {
            return null;
        }
    };
    return Query;
})();
queryStructure.Container = (function () {
    function Container(parent, children, name, title, negate) {
        this.parent = parent;
        this.children = children != null ? children : [];
        this.name = name;
        this.title = title;
        this.negate = negate != null ? negate : false;
        this.children || (this.children = []);
    }

    Container.prototype.add = function (element, after) {
        var ci, index;
        index = this.children.length;
        ci = this.childIndex(after);
        if (ci !== -1) index = ci + 1;
        this.children.splice(index, 0, element);
        if (element.parent && element.parent !== this) {
            element.parent.removeChild(element);
        }
        element.parent = this;
        return element;
    };
    Container.prototype.addAll = function (items, after) {
        var item, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
            item = items[_i];
            _results.push(after = this.add(item, after));
        }
        return _results;
    };
    Container.prototype.remove = function () {
        if (this.parent) return this.parent.removeChild(this);
    };
    Container.prototype.removeChild = function (victim) {
        var index;
        index = this.childIndex(victim);
        if (index !== -1) {
            this.children.splice(index, 1);
            return victim.parent = null;
        }
    };
    Container.prototype.replaceChild = function (child, newChild) {
        var index;
        index = this.childIndex(child);
        if (index !== -1) {
            this.children[index] = newChild;
            child.parent = null;
            return newChild.parent = this;
        }
    };
    Container.prototype.moveBefore = function (child, other) {
        var i1, i2;
        i1 = this.childIndex(child);
        i2 = this.childIndex(other);
        if (i1 !== -1 && i2 !== -1) {
            child = this.children.splice(i2, 1);
            this.children.splice(i1 - 1, 0, other);
            return true;
        }
        return false;
    };
    Container.prototype.childIndex = function (child) {
        var index, _child, _ref;
        if (child === null) return -1;
        _ref = this.children;
        for (index in _ref) {
            _child = _ref[index];
            if (_child === child) return index;
        }
        return -1;
    };
    Container.prototype.clear = function () {
        return this.children = [];
    };
    Container.prototype.childrenToJson = function () {
        var child, childJson, js, _i, _len, _ref;
        childJson = [];
        _ref = this.children;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            js = child["toJson"] ? child.toJson() : child;
            childJson.push(js);
        }
        return childJson;
    };
    return Container;
})();
queryStructure.Or = (function () {
    __extends(Or, queryStructure.Container);
    function Or() {
        Or.__super__.constructor.apply(this, arguments);
    }

    Or.prototype.toJson = function () {
        var childJson;
        childJson = this.childrenToJson();
        return {      "name": this.name, "or": childJson, "negate": this.negate, "title": this.title    };
    };
    Or.prototype.test = function (patient) {
        var child, retval, _i, _len, _ref;
        if (this.children.length === 0) return true;
        retval = false;
        _ref = this.children;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            if (child.test(patient)) {
                retval = true;
                break;
            }
        }
        if (this.negate) {
            return !retval;
        } else {
            return retval;
        }
    };
    return Or;
})();
queryStructure.And = (function () {
    __extends(And, queryStructure.Container);
    function And() {
        And.__super__.constructor.apply(this, arguments);
    }

    And.prototype.toJson = function () {
        var childJson;
        childJson = this.childrenToJson();
        return {      "name": this.name, "and": childJson, "negate": this.negate, "title": this.title    };
    };
    And.prototype.test = function (patient) {
        var child, retval, _i, _len, _ref;
        if (this.children.length === 0) return true;
        retval = true;
        _ref = this.children;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            if (!child.test(patient)) {
                retval = false;
                break;
            }
        }
        if (this.negate) {
            return !retval;
        } else {
            return retval;
        }
    };
    return And;
})();
queryStructure.Field = (function () {
    function Field(title, callstack) {
        this.title = title;
        this.callstack = callstack;
    }

    Field.prototype.toJson = function () {
        return {      "title": this.title, "callstack": this.callstack    };
    };
    Field.prototype.extract = function (patient) {
        return patient[callstack]();
    };
    return Field;
})();
queryStructure.Group = (function () {
    __extends(Group, queryStructure.Field);
    function Group(title, callstack) {
        this.title = title;
        this.callstack = callstack;
    }

    Group.rebuildFromJson = function (json) {
        return new queryStructure.Group(json['title'], json['callstack']);
    };
    return Group;
})();
queryStructure.Selection = (function () {
    __extends(Selection, queryStructure.Field);
    function Selection(title, callstack, aggregation) {
        this.title = title;
        this.callstack = callstack;
        this.aggregation = aggregation;
    }

    Selection.prototype.toJson = function () {
        return {      "title": this.title, "callstack": this.callstack, 'aggregation': this.aggregation    };
    };
    Selection.rebuildFromJson = function (json) {
        return new queryStructure.Selection(json['title'], json['callstack'], json['aggregation']);
    };
    return Selection;
})();
queryStructure.Extraction = (function () {
    function Extraction(selections, groups) {
        this.selections = selections;
        this.groups = groups;
    }

    Extraction.prototype.toJson = function () {
        var group, groupJson, selectJson, selection, _i, _j, _len, _len2, _ref, _ref2;
        selectJson = [];
        groupJson = [];
        _ref = this.selections;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            selection = _ref[_i];
            selectJson.push(selection.toJson());
        }
        _ref2 = this.groups;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            group = _ref2[_j];
            groupJson.push(group.toJson());
        }
        return {      "selections": selectJson, "groups": groupJson    };
    };
    Extraction.rebuildFromJson = function (json) {
        var group, groups, selection, selections, _i, _j, _len, _len2, _ref, _ref2;
        selections = [];
        groups = [];
        _ref = json['selections'];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            selection = _ref[_i];
            selections.push(queryStructure.Selection.rebuildFromJson(selection));
        }
        _ref2 = json['groups'];
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            group = _ref2[_j];
            groups.push(queryStructure.Group.rebuildFromJson(group));
        }
        return new queryStructure.Extraction(selections, groups);
    };
    return Extraction;
})();
var reducer;
reducer = this.reducer || {};
reducer.Value = (function () {
    function Value(values, rereduced) {
        this.values = values;
        this.rereduced = rereduced;
    }

    Value.prototype.sum = function (title, element) {
        if (!this.rereduced) this.values[title + '_sum'] = 0;
        if (!element.rereduced) element.values[title + '_sum'] = 0;
        return this.values[title + '_sum'] += element.values[title] + element.values[title + '_sum'];
    };
    Value.prototype.frequency = function (title, element) {
        var k, key, v, _ref, _results;
        if (!this.rereduced) this.values[title + '_frequency'] = {};
        if (!element.rereduced) {
            element.values[title + '_frequency'] = {};
            key = ('' + element.values[title]).replace('.', '~');
            element.values[title + '_frequency'][key] = 1;
        }
        _ref = element.values[title + '_frequency'];
        _results = [];
        for (k in _ref) {
            v = _ref[k];
            if (this.values[title + '_frequency'][k] != null) {
                _results.push(this.values[title + '_frequency'][k] += v);
            } else {
                _results.push(this.values[title + '_frequency'][k] = v);
            }
        }
        return _results;
    };
    Value.prototype.mean = function (title, element) {
        var count, elementTotal, previousTotal, total;
        if (!this.rereduced) {
            this.values[title + '_mean'] = 0;
            this.values[title + '_mean_count'] = 0;
        }
        if (!element.rereduced) {
            element.values[title + '_mean'] = element.values[title];
            element.values[title + '_mean_count'] = 1;
        }
        previousTotal = this.values[title + '_mean'] * this.values[title + '_mean_count'];
        elementTotal = element.values[title + '_mean'] * element.values[title + '_mean_count'];
        total = previousTotal + elementTotal;
        count = this.values[title + '_mean_count'] + element.values[title + '_mean_count'];
        this.values[title + '_mean_count'] = count;
        return this.values[title + '_mean'] = total / count;
    };
    Value.prototype.median = function (title, element) {
        var front_value, i, leftCenter, rightCenter, value, _i, _len, _ref;
        if (!this.rereduced) this.values[title + '_median_list'] = [];
        if (!element.rereduced) {
            element.values[title + '_median_list'] = [element.values[title]];
        }
        i = 0;
        while (i < this.values[title + '_median_list'].length && element.values[title + '_median_list'].length > 0) {
            while (element.values[title + '_median_list'].length > 0 && element.values[title + '_median_list'][0] < this.values[title + '_median_list'][i]) {
                front_value = (element.values[title + '_median_list'].splice(0, 1))[0];
                this.values[title + '_median_list'].splice(i, 0, front_value);
                i++;
            }
            i++;
        }
        _ref = element.values[title + '_median_list'];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            value = _ref[_i];
            this.values[title + '_median_list'].splice(this.values[title + '_median_list'].length, 0, value);
        }
        if (this.values[title + '_median_list'].length % 2 === 0) {
            leftCenter = this.values[title + '_median_list'][Math.floor(this.values[title + '_median_list'].length / 2)];
            rightCenter = this.values[title + '_median_list'][Math.floor(this.values[title + '_median_list'].length / 2) - 1];
            return this.values[title + '_median'] = (leftCenter + rightCenter) / 2;
        } else {
            return this.values[title + '_median'] = this.values[title + '_median_list'][Math.floor(this.values[title + '_median_list'].length / 2)];
        }
    };
    Value.prototype.mode = function (title, element) {
        var key, most_frequent_key, most_frequent_value, value, _ref, _ref2;
        if (!this.rereduced) this.values[title + '_mode_frequency'] = {};
        if (!element.rereduced) {
            element.values[title + '_mode_frequency'] = {};
            key = ('' + element.values[title]).replace('.', '~');
            element.values[title + '_mode_frequency'][key] = 1;
        }
        _ref = element.values[title + '_mode_frequency'];
        for (key in _ref) {
            value = _ref[key];
            if (this.values[title + '_mode_frequency'][key] != null) {
                this.values[title + '_mode_frequency'][key] += 1;
            } else {
                this.values[title + '_mode_frequency'][key] = 1;
            }
        }
        most_frequent_key = [];
        most_frequent_value = 0;
        _ref2 = this.values[title + '_mode_frequency'];
        for (key in _ref2) {
            value = _ref2[key];
            if (value === most_frequent_value) {
                most_frequent_key.push(key);
            } else if (value > most_frequent_value) {
                most_frequent_key = [key];
                most_frequent_value = value;
            }
        }
        return this.values[title + '_mode'] = most_frequent_key;
    };
    return Value;
})();
var __hasProp = Object.prototype.hasOwnProperty, __extends = function (child, parent) {
    for (var key in parent) {
        if (__hasProp.call(parent, key)) child[key] = parent[key];
    }
    function ctor() {
        this.constructor = child;
    }

    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
};
this.queryStructure || (this.queryStructure = {});
queryStructure.Rule = (function () {
    function Rule(name, data) {
        this.name = name;
        this.data = data;
        this.type = this.constructor.name;
    }

    Rule.prototype.toJson = function () {
        return {      "name": this.name, "type": this.type, "data": this.data    };
    };
    return Rule;
})();
queryStructure.Range = (function () {
    function Range(category, title, field, start, end) {
        this.category = category;
        this.title = title;
        this.field = field;
        this.start = start;
        this.end = end;
    }

    return Range;
})();
queryStructure.Comparison = (function () {
    function Comparison(data) {
        Comparison.__super__.constructor.call(this, "ComparisonRule", data);
    }

    Comparison.prototype.test = function (patient) {
        var value;
        value = null;
        if (this.field === 'age') {
            value = patient[this.field](new Date());
        } else {
            value = patient[this.field]();
        }
        if (this.comparator === '=') {
            return value === this.value;
        } else if (this.comparator === '<') {
            return value < this.value;
        } else {
            return value > this.value;
        }
    };
    return Comparison;
})();
queryStructure.CodeSetRule = (function () {
    __extends(CodeSetRule, queryStructure.Rule);
    function CodeSetRule(data) {
        CodeSetRule.__super__.constructor.call(this, data.type, data);
        this.code_set_type = data.type;
    }

    CodeSetRule.prototype.test = function (p) {
        var codes;
        if (this.data.code === null) return true;
        codes = p[this.code_set_type]().match(this.data.code.codes);
        return codes.length !== 0;
    };
    return CodeSetRule;
})();
queryStructure.VitalSignRule = (function () {
    __extends(VitalSignRule, queryStructure.Rule);
    function VitalSignRule(data) {
        VitalSignRule.__super__.constructor.call(this, "VitalSignRule", data);
    }

    VitalSignRule.prototype.test = function (p) {
        var codes;
        if (this.data.code === null) return true;
        codes = p.vitalSigns().match(this.data.code.codes);
        return codes.length !== 0;
    };
    return VitalSignRule;
})();
queryStructure.EncounterRule = (function () {
    __extends(EncounterRule, queryStructure.Rule);
    function EncounterRule(data) {
        EncounterRule.__super__.constructor.call(this, "EncounterRule", data);
    }

    EncounterRule.prototype.test = function (p) {
        var codes;
        if (this.data.code === null) return true;
        codes = p.encounters().match(this.data.code.codes);
        return codes.length !== 0;
    };
    return EncounterRule;
})();
queryStructure.DemographicRule = (function () {
    __extends(DemographicRule, queryStructure.Rule);
    function DemographicRule(data) {
        DemographicRule.__super__.constructor.call(this, "DemographicRule", data);
    }

    DemographicRule.prototype.test = function (p) {
        var match, status;
        match = true;
        if (this.data.ageRange) {
            match = p.age() >= this.data.ageRange.low && p.age() <= this.data.ageRange.high;
        }
        if (this.data.maritalStatusCode && match) {
            status = p.maritalStatus();
            match = status && status.includesCodeFrom(this.data.maritalStatusCode.codes);
        }
        if (this.data.gender && match) match = p.gender() === this.data.gender;
        if (this.data.raceCode && match) {
            match = p.race().includesCodeFrom(this.data.raceCode.codes);
        }
        return match;
    };
    return DemographicRule;
})();
queryStructure.RawJavascriptRule = (function () {
    __extends(RawJavascriptRule, queryStructure.Rule);
    function RawJavascriptRule(data) {
        RawJavascriptRule.__super__.constructor.call(this, "RawJavascriptRule", data);
    }

    RawJavascriptRule.prototype.test = function (p) {
        if (this.data && this.data.js) {
            try {
                eval("var jscript = " + this.data.js);
                return jscript(p);
            } catch (_error) {
            }
        }
    };
    return RawJavascriptRule;
})();