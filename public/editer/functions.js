/**
 * @author Victor Potapov
 * @date 2014
 * @version 4.0.1
 */

function download(filename, text) {
    var element = document.createElement("a");
    element.setAttribute("href", "data:text/plain;charset=utf-8," + encodeURIComponent(text));
    element.setAttribute("download", filename);

    element.style.display = "none";
    document.body.appendChild(element);

    element.click();

    document.body.removeChild(element);
}

var functions = {
    random: function (from, to) {
        return Math.round(Math.random() * (from - to)) + to;
    },
    randomFloat: function (from, to) {
        return parseFloat((Math.random() * (from - to) + to).toFixed(2));
    },
    randomFloatNotRepeat: function (from, to) {
        var n = parseFloat((Math.random() * (from - to) + to).toFixed(2));
        while ($.inArray(n, KB.powers) !== -1) {
            n = parseFloat((Math.random() * (from - to) + to).toFixed(2));
        }
        KB.powers.push(n);
        return n;
    },
    showWindowAction: function () {
        var heightBody = $("body").height();
        var widthBody = $("body").width();
        var cleanLeftForModal = widthBody / 2 - $("#select_div_msg").width() / 2;
        var cleanTopForModal = $(window).height() / 2 - $("#select_div_msg").height() + 100;
        $("#select_div").css({
            height: heightBody + "px",
        });
        $("#select_div_msg").css({
            left: cleanLeftForModal + "px",
            top: cleanTopForModal + "px",
        });

        this.createCheckboxForMemory(false);
        $("#select_div").fadeIn();
        $("#select_div_msg").slideDown();
        $("#select_div_msg").draggable();
    },
    showWindowActionReverse: function () {
        var heightBody = $("body").height();
        var widthBody = $("body").width();
        var cleanLeftForModal = widthBody / 2 - $("#select_div_msg").width() / 2;
        var cleanTopForModal = $(window).height() / 2 - $("#select_div_msg").height() + 100;
        $("#select_div").css({
            height: heightBody + "px",
        });
        $("#select_div_msg").css({
            left: cleanLeftForModal + "px",
            top: cleanTopForModal + "px",
        });

        this.createCheckboxForMemory(false);
        this.createRadioForGoal();
        $("#select_div").fadeIn();
        $("#select_div_msg").slideDown();
        $("#select_div_msg").draggable();
    },
    createCheckboxForMemory: function (flag, editObj) {
        var s = "";
        for (var _i = 0; _i < KB.depth + 1; _i++) {
            s += "," + KB.data[_i];
        }
        s = s.toString().split(",");
        $("#select_fact").html("");

        for (var _i = 0; _i < s.length; _i++) {
            var need = s[_i];
            if (need !== "") {
                if (flag == true) {
                    if ($.inArray(need, KB.fullMemory) != -1) {
                    } else {
                        $("#select_fact").append($('<input type="checkbox" value="' + need + '">' + need + "<br />"));
                    }
                } else {
                    $("#select_fact").append($('<input type="checkbox" value="' + need + '">' + need + "<br />"));
                }
            }
        }
    },
    createRadioForGoal: function () {
        var s = "";
        for (var _i = 0; _i < KB.depth; _i++) {
            s += "," + KB.data[_i];
        }
        s = s.toString().split(",");
        $("#goal_select").html("");

        for (var _i = 0; _i < s.length; _i++) {
            var need = s[_i];
            if (need !== "") {
                $("#goal_select").append(
                    $(
                        '<input name="goal" type="radio" value="' +
                            need +
                            '" id="general_goal_' +
                            _i +
                            '"> <label for="general_goal_' +
                            _i +
                            '">' +
                            need +
                            "</label><br />"
                    )
                );
            }
        }
    },
    showWindowClick: function (r, editFlag) {
        var heightBody = $("body").height();
        var widthBody = $("body").width();
        var cleanLeftForModal = widthBody / 2 - $("#select_div_msg").width() / 2;
        var cleanTopForModal = $(window).height() / 2 - $("#select_div_msg").height() + 100;
        $("#select_div").css({
            height: heightBody + "px",
        });
        $("#select_div_msg").css({
            left: cleanLeftForModal + "px",
            top: cleanTopForModal + "px",
        });
        if (editFlag && editFlag == true) {
            this.createCheckboxForMemory(true, { rule: r._rule });
            this._constructTableRule(r._rule.activeRules);
        } else {
            this.createCheckboxForMemory(true);
            this._constructTableRule(r._rule);
        }

        $("#select_div").fadeIn();
        $("#select_div_msg").slideDown();
    },
    showWindowClickReverse: function (r, editFlag) {
        var heightBody = $("body").height();
        var widthBody = $("body").width();
        var cleanLeftForModal = widthBody / 2 - $("#select_div_msg").width() / 2;
        var cleanTopForModal = $(window).height() / 2 - $("#select_div_msg").height() + 100;
        $("#select_div").css({
            height: heightBody + "px",
        });
        $("#select_div_msg").css({
            left: cleanLeftForModal + "px",
            top: cleanTopForModal + "px",
        });
        if (editFlag && editFlag == true) {
            this.createRadioForGoal();
            this.createCheckboxForMemory(true, { rule: r._rule });
            this._constructTableRule(r._rule.activeRules);
        } else {
            this.createRadioForGoal();
            this.createCheckboxForMemory(true);
            this._constructTableRule(r._rule);
        }

        $("#select_div").fadeIn();
        $("#select_div_msg").slideDown();
    },
    _constructTableRule: function (activeRule) {
        var exitCode = "";
        if (!activeRule.splice) {
            activeRule = [activeRule];
        }
        exitCode =
            '<tr><td width="30"></td><td class="title_tbl_rule" width="100" align="center">Подходит</td><td class="title_tbl_rule" width="100" align="center">Не подходит</td><td class="title_tbl_rule" width="130" align="center">Уже используется</td></tr>';
        for (var o in KB.rules) {
            if (o !== "length") {
                if ($.inArray(KB.rules[o], activeRule) !== -1) {
                    exitCode =
                        exitCode +
                        '<tr id="out-R' +
                        o +
                        '" class="tr_tbl_rule"><td class="name_tbl_rule">R' +
                        o +
                        '</td><td class="easy_val" align="center"><input type="radio" checked="cheched" class="S" name="R' +
                        o +
                        '" id="R' +
                        o +
                        '-S" /></td>' +
                        '<td class="easy_val" align="center"><input type="radio"  class="H" name="R' +
                        o +
                        '" id="R' +
                        o +
                        '-H" /></td>' +
                        '<td class="easy_val" align="center"><input type="radio" class="P" name="R' +
                        o +
                        '" id="R' +
                        o +
                        '-P" /></td></tr>';
                } else {
                    exitCode =
                        exitCode +
                        '<tr id="out-R' +
                        o +
                        '" class="tr_tbl_rule"><td class="name_tbl_rule">R' +
                        o +
                        '</td><td class="easy_val" align="center"><input type="radio" class="S" name="R' +
                        o +
                        '" id="R' +
                        o +
                        '-S" /></td>' +
                        '<td class="easy_val" align="center"><input type="radio" checked="cheched" class="H" name="R' +
                        o +
                        '" id="R' +
                        o +
                        '-H" /></td>' +
                        '<td class="easy_val" align="center"><input type="radio" class="P" name="R' +
                        o +
                        '" id="R' +
                        o +
                        '-P" /></td></tr>';
                }
            }
        }
        exitCode = '<table class="radio_rule" border="0">' + exitCode + "</table>";
        $("#table_check").html(exitCode);
        $(".tr_tbl_rule:even").css("background-color", "#efeff0");
        $(" .tr_tbl_rule:odd").css("background-color", "#b3b3b3");
    },
    selectSituation: function () {
        KB.counterSteps += 1;
        var s = [];
        var traceRule = [];
        var selectRule = [];
        var activeRule = [],
            checkRule = [],
            notActiveRule = [];
        var steckGoal = [];
        $("#select_fact input:checked").each(function (indx, element) {
            s.push($(this).val());

            KB.fullMemory.push($(this).val());
        });
        $("#goal_select input:checked").each(function (indx, element) {
            steckGoal.push($(this).val());
        });
        functions.deleteValFromArray(steckGoal.toString(), KB.steckSubGoal);
        for (var a in KB.rules) {
            if (a !== "length") {
                var rtn = $("#out-R" + a + " input:checked").attr("class");

                traceRule.push(rtn);

                if (rtn == "S") {
                    var l = draw.line.setActiveAttr(KB.rules[a].raphael);
                    activeRule.push(KB.rules[a]);
                    selectRule.push(l);
                }
                if (rtn == "P") {
                    checkRule.push(KB.rules[a]);
                }
                if (rtn == "H") {
                    notActiveRule.push(KB.rules[a]);
                }
            }
        }

        if (KB.editNow == true) {
            KB.memoryStep.splice(KB.editPosition, 1, {
                step: KB.editPosition + 1,
                memory: s,
                rule: traceRule,
                raphael: selectRule,
                activeRules: activeRule,
                checkRules: checkRule,
                notActiveRules: notActiveRule,
                steckGoals: steckGoal.toString(),
            });

            KB.counterSteps -= 1;
            KB.editNow = false;
        } else {
            KB.memoryStep.push({
                step: KB.counterSteps,
                memory: s,
                rule: traceRule,
                raphael: selectRule,
                activeRules: activeRule,
                checkRules: checkRule,
                notActiveRules: notActiveRule,
                steckGoals: steckGoal.toString(),
            });
        }

        draw.facts.redraw(s);

        this._createTraceTable("trace");

        this.checkFullMemory();

        this.redrawMemory();
        if (KB.steckSubGoal.length > 0) {
            draw.facts.goalDraw([KB.steckSubGoal[KB.steckSubGoal.length - 1]]);
        }
        $("#select_div").fadeOut();
        $("#select_div_msg").slideUp();
    },
    selectGoal: function (name) {
        KB.counterSteps += 1;
        var s = [];
        var traceRule = [];
        var selectRule = [];
        var activeRule = [],
            checkRule = [],
            notActiveRule = [];

        KB.memoryStep.push({
            step: KB.counterSteps,
            memory: s,
            rule: traceRule,
            raphael: selectRule,
            activeRules: activeRule,
            checkRules: checkRule,
            notActiveRules: notActiveRule,
            subGoal: name,
        });
        this._createTraceTable("trace");
    },
    cancelSituation: function () {
        var need = KB.activeRuleSVG;
        need._clickActive = false;
        need.attr(draw.line.circleStyle);
        var t = need._allLine;
        for (var m = 0; m < t.items.length; m++) {
            t.items[m].attr(draw.line.style);
        }
        this.checkFullMemory();
        $("#select_div").fadeOut();
        $("#select_div_msg").slideUp();
        need = {};
    },
    _createTraceTable: function (id) {
        $("#trace_val").html("");
        document.getElementById(id).innerHTML = "";

        var rules = KB.rules;
        var width = rules.length * 40 + 280;
        var b = "";
        for (var _i = 0; _i < parseInt(rules.length); _i++) {
            b +=
                '<td class="name_rule_trace" width="40" align="center"><div style="display:block; width:40px;">R' +
                (_i + 1) +
                "</div></td>";
        }

        var c =
            '<table border="0" cellspacing="3" width="' +
            width +
            '" align="center"><tr><td><div style="display:block; width:50px;"><div id="check_scroll_me" style="position:absolute"></div></div></td>' +
            b +
            '<td class="name_rule_trace">' +
            '<div style="display:block; width:100px;">Изменение РП</div></td><td><div style="display:block; width:100px;">Изменение подцели</div></td><td><div style="display:block; width:70px;"><b>Функции</b></div></td></tr></table><div id="trace_val"></div>';

        $("#" + id).html(c);

        for (var _t = 0; _t < KB.memoryStep.length; _t++) {
            var d = "";
            var optionsRule =
                '<a href="javascript://" onClick="functions.editStep(KB.memoryStep[' +
                _t +
                ']);" title="Редактировать">Р</a>';
            if (_t == KB.memoryStep.length - 1) {
                optionsRule +=
                    ' <a href="javascript://" onClick="functions.deleteStep(KB.memoryStep[' +
                    _t +
                    ']);" title="Удаление шага" class="del_btn">Х</a>';
            }
            if (KB.memoryStep[_t].subGoal) {
                d +=
                    '<td><div style="display:block; width:' +
                    (parseInt(width) - 40) +
                    'px;">Изменение подцели ' +
                    KB.memoryStep[_t].subGoal +
                    "</div></td>";
            } else {
                for (var _tt = 0; _tt < KB.memoryStep[_t].rule.length; _tt++) {
                    var needRule = KB.memoryStep[_t].rule;
                    var rtn = needRule[_tt];
                    d += '<td class="make_' + rtn + '" width="40"><div style="display:block; width:40px;"></div></td>';
                }
            }
            d =
                '<table class="tbl_step_rule" id="tbl_step_' +
                (_t + 1) +
                '" cellspacing="3" border="0" width="' +
                width +
                '" align="center"><tr><td width="50" class="name_rule_trace"><div style="display:block; width:50px;">Шаг ' +
                (_t + 1) +
                "</div></td>" +
                d +
                '<td><div style="display:block; width:100px;" id="change_memory-step' +
                (_t + 1) +
                '">' +
                (KB.memoryStep[_t].memory ? KB.memoryStep[_t].memory.toString() : "") +
                '</div></td><td><div style="display:block; width:100px;" id="change_goal-step' +
                (_t + 1) +
                '">- ' +
                (KB.memoryStep[_t].steckGoals ? KB.memoryStep[_t].steckGoals.toString() : "") +
                '</div></td><td class="function_trace_step"><div style="display:block; width:70px;">' +
                optionsRule +
                ' </div></td></tr></table><br id="br_' +
                (_t + 1) +
                '" />';

            $("#trace_val").html($("#trace_val").html() + d);
        }
    },
    editStep: function (step) {
        for (var t = 0; t < KB.memoryStep.length; t++) {
            var checker = KB.memoryStep[t];
            if (step == checker) {
                KB.editPosition = step.step - 1;
                KB.editNow = true;
                var needObj = {
                    _rule: step,
                };

                var needArr = KB.firstMemory.toString().split(",");
                for (var _k = 0; _k < KB.memoryStep.length; _k++) {
                    if (KB.memoryStep[_k].memory.length != 0) {
                        if (KB.memoryStep[_k] == step) {
                            break;
                        }
                        for (var _l = 0; _l < KB.memoryStep[_k].memory.length; _l++) {
                            needArr.push(KB.memoryStep[_k].memory[_l]);
                        }
                    }
                }
                KB.fullMemory = needArr;
                this.showWindowClick(needObj, true);
            }
        }
    },
    deleteStep: function (step) {
        var need = KB.memoryStep.pop();
        KB.counterSteps -= 1;
        if (need.subGoal) {
            draw.facts.setStandart([need.subGoal]);
            KB.steckSubGoal.pop();
            if (KB.steckSubGoal.length != 1) {
                draw.facts.goalDraw([KB.steckSubGoal[KB.steckSubGoal.length - 1]]);
            } else {
                draw.facts.goalDraw([KB.steckSubGoal[0]]);
            }
        } else {
            if (need.steckGoals) {
                draw.facts.setStandart(KB.steckSubGoal);
                KB.steckSubGoal.push(need.steckGoals);
                draw.facts.goalDraw(need.steckGoals);
            }
            draw.line.setStandartAttr(need.raphael);
            draw.facts.setStandart(need.memory);

            this.deleteFromArray(need.memory, KB.fullMemory);
        }
        this._createTraceTable("trace");
    },
    deleteFromArray: function (arr, where) {
        for (var i = 0; i < arr.length; i++) {
            var needNum = 0;
            for (var t = 0; t < where.length; t++) {
                if (where[t] == arr[i]) {
                    needNum = t;
                }
            }
            where.splice(needNum, 1);
        }
    },
    deleteValFromArray: function (val, arr) {
        for (var t = 0; t < arr.length; t++) {
            if (val == arr[t]) {
                arr.splice(t, 1);
                break;
            }
        }
    },
    memoryOnStep: function (stepNumber) {},
    checkFullMemory: function () {
        var out = KB.firstMemory.toString().split(",");

        for (var n = 0; n < KB.memoryStep.length; n++) {
            for (var t = 0; t < KB.memoryStep[n].memory.length; t++) {
                out.push(KB.memoryStep[n].memory[t]);
            }
        }
        KB.fullMemory = out;
    },
    redrawMemory: function () {
        for (var i = 0; i < draw.facts.cache.items.length; i++) {
            var a = draw.facts.cache.items[i].attrs.title;
            draw.facts.style.title = a;
            draw.facts.cache.items[i].attr(draw.facts.style);
        }
        draw.facts.redraw(KB.fullMemory);
    },
    checkTwoArray: function (arr1, arr2) {
        if (arr1 == undefined) return false;
        //TODO: Сравнивает два массива. Если второй содержит все элементы первого возвращает true иначе false
        for (n = 0; n < arr1.length; n++) {
            if ($.inArray(arr1[n], arr2) == -1) {
                return false;
                break;
            }
        }
        return true;
    },
    refactorArray: function (array) {
        /*
         * Переопределяет массив. возвращает новый массив;
         * ссылки теряют свой смысл
         */
        var a = [];
        for (var i = 0; i < array.length; i++) {
            a.push(array[i]);
        }
        return a;
    },
    equalArray: function (arr1, arr2) {
        if (arr1.length == arr2.length) {
            for (var b = 0; b < arr2.length; b++) {
                if ($.inArray(arr1[b], arr2) !== -1) {
                } else {
                    return false;
                    break;
                }
            }
            return true;
        } else {
            return false;
        }
    },
    createNewFact: function () {
        this.createWindowForFact();
        this.initDepth();
    },
    createWindowForFact: function () {
        var heightBody = $("body").height();
        var widthBody = $("body").width();
        var cleanLeftForModal = widthBody / 2 - $("#select_div_msg").width() / 2;
        var cleanTopForModal = $(window).height() / 2 - $("#select_div_msg").height() + 100;
        $("#select_div").css({
            height: heightBody + "px",
        });
        $("#select_div_msg").css({
            left: cleanLeftForModal + "px",
            top: cleanTopForModal + "px",
        });

        this.createCheckboxForMemory(false);
        $("#select_div").fadeIn();
        $("#select_div_msg").slideDown();
        $("#select_div_msg").draggable();
    },
    initDepth: function () {
        $("#level_select").html("");
        var s = '<ul class="level_select">';
        for (var i = 0; i < KB.depth + 1; i++) {
            s += '<li><a href="javascript://" onClick="functions.editLevel(' + i + ');">' + i + " Уровень</a></li>";
        }
        s += "</ul>";
        $("#level_select").html(s);
    },
    editLevel: function (l) {
        $("#fact_names").html("");
        var s = '<div class="level_title">' + l + " Уровень</div>";
        s += '<ul id="level_' + l + '" class="facts_name_level">';
        for (var k = 0; k < KB.data[l].length; k++) {
            s +=
                '<li><input type="text" value="' +
                KB.data[l][k] +
                '" /> <a href="javascript://" onClick="functions.deleteDataFromKB(' +
                l +
                "," +
                k +
                ');" title="Удалить данный факт"><img src="../editer/delete.png" border="0" /></a></li>';
        }
        s +=
            "</ul>" +
            '<div><input type="button" class="button_generate2" style="margin:5px;" value="Добавить новый факт" onClick="functions.addFactToData(' +
            l +
            ');" /></div>' +
            '<input type="button" class="button_generate2" style="margin:5px;" value="Готово" onClick="functions.addNewFact(' +
            l +
            ');" /></div>';
        $("#fact_names").html(s);
    },
    deleteDataFromKB: function (level, num) {
        this.deleteValFromArray(KB.data[level][num], KB.data[level]);
        this.editLevel(level);
    },
    addFactToData: function (level) {
        var newF = prompt("Введите название нового факта", "");
        if (newF == null || newF == "") {
        } else {
            $("#level_" + level).append('<li><input type="text" value="' + newF + '" /></li>');
        }
    },
    addNewFact: function (level) {
        var a = KB.data[level];
        a = [];
        $("#level_" + level + " > li > input").map(function (indx, element) {
            a.push($(element).val());
        });
        KB.data[level] = a.concat();
        $.jGrowl("Изменения учтены", 3000);
    },
    checkRedrawTree: function () {
        var s = confirm("Вы уверены что сохранили все изменения?");
        if (s) {
            KB.reloadMemory();
            $("#select_div").fadeOut();
            $("#select_div_msg").slideUp();
        }
    },
    saveJSON: function (flag, express) {
        var arr = [];
        for (var key in KB.rules) {
            if (key !== "length") {
                arr.push({
                    node: KB.rules[key].node,
                    children: KB.rules[key].children.concat(),
                    startPower: KB.rules[key].startPower,
                    number: KB.rules[key].number,
                });
            }
        }
        var s = JSON.stringify({ data: KB.data, depth: KB.depth, rules: arr });
        if (express) {
            return s;
        }
        if (flag) {
            return $.parseJSON(s);
        } else var n = prompt("Скопируйте этот код в блокнот.(CTRL+A -> CTRL+C -> CTRL+V)", s);
    },
    JSONtoStringFile: function () {
        var json = this.saveJSON(true);
        var s = "";
        for (var t = 0; t < json.rules.length; t++) {
            var need = json.rules[t];

            if (need.children.length !== 0) {
                s += "ЕСЛИ";
                for (var k = 0; k < need.children.length; k++) {
                    s += " <" + need.children[k] + "> И";
                    if (k == need.children.length - 1) {
                        s = s.slice(0, -1);
                    }
                }
                s += "ТО <" + need.node + ">; \n \n";
            }
        }
        $("#ruleOnRussia").fadeIn();
        $("#ruleOnRussia_text").text(s);
        $.jGrowl("Правила построены в низу страницы", 3000);
    },
    solveAction: function (val) {
        if (val) {
            var iframeDoc = window.parent;
        }
        var u = val ? iframeDoc._forwardReverse : document.getElementById("modelJSON").value;
        var obj = $.parseJSON(u);
        if (u.length !== 0) {
            this.checkModel(obj);
            KB.buildKB(obj);
        } else {
            KB.generate("baza_text");
            KB.save("baza_text", "holder");
        }
    },
    saveModelFromEditJSON: function () {
        var s = this.saveJSON(true, true);
        download("rules.json", s);
        document.getElementById("JSONResult").getElementsByTagName("textarea")[0].value = s;
        var model = this.saveJSON(true);
        window.parent._forwardReverse = s;

        this.checkModel(model);
    },
    closeEditFrame: function () {
        $("#checkFrameDiv").fadeOut();
        document.getElementById("checkFrame").src = "";

        document.getElementById("JSONfile").value = window._forwardReverse;
    },
    checkModel: function (model) {
        /*
         * <model> - JSON модели
         * Проверка на выполнение минимальных требований
         */
        var out = new Object();
        var o1 = [],
            o2 = [],
            count = 0;
        for (var i = 1; i < model.data.length; i++) {
            if (model.data[i].length < 4) {
                count++;
                o1.push(model.data[i]);
            }
        }
        if (o1.length != 0) {
            out["Мало фактов на уровнях"] = {
                flag: true,
                "В требованиях указано(мин.)": 4,
                "Подтверждающие данные": o1,
            };
        }
        if (model.depth < 4) {
            count++;
            out["Малая глубина вывода"] = {
                flag: true,
                "В требованиях указано": 4,
                "Глубина модели обучаемого": model.depth,
            };
        }
        for (var key in model.rules) {
            var r = model.rules[key];
            if (r.children.length < 2) {
                count++;
                o2.push({ "Условий в ЛЧП": r.children, "Номер правила": r.number });
            }
        }
        if (o2.length != 0) {
            out["Мало условий в правилах"] = {
                flag: true,
                "Должно быть условий в ЛЧП(мин)": 2,
                "Подтверждающие данные": o2,
            };
        }
        if (out["Мало условий в правилах"] || out["Малая глубина вывода"] || out["Мало фактов на уровнях"]) {
            $.jGrowl("Ошибки при построении модели. Смотри консоль");
            $("#CONSOLE").fadeIn();
            out["Количество ошибок"] = count;
            $("#consoleText").text(JSON.stringify(out, "", 4));
        }
    },

    getJSONmodel: function () {
        var jqxhr = $.getJSON("/JSON/" + $("#user_name_now").val() + "_save.json")
            .success(function (data) {
                KB.buildKB(data);
                functions.p2s({
                    id: $("#user_id_now").val(),
                    end: "no",
                    url: "http://localhost:3000/" + $("#name_component").val().toString() + "/getfile",
                });
                setTimeout('$("#loading_win").fadeOut();', 2700);
            })
            .error(function (data) {
                alert("Ошибка выполнения");
                console.log(data);
            });
    },
    result: function (met) {
        if (met == "R") {
            var o = solverR.estimate();
            var need = {
                name: $("#user_name_now").val(),
                e: o.e,
                id: $("#user_id_now").val(),
                end: "yes",
                trace: this.TraceR(KB.memoryStep),
                url: "http://localhost:3000/reverse/getfile",
            };
            this.p2s(need);
            $("#set_block").fadeIn();
        } else {
            var o = solverF.estimate();
            var need = {
                name: $("#user_name_now").val(),
                e: o.e,
                id: $("#user_id_now").val(),
                end: "yes",
                trace: this.TraceF(KB.memoryStep),
                url: "http://localhost:3000/menu/getfile",
            };

            this.p2s(need);
            $("#set_block").fadeIn();
            alert("Ваша оценка: " + o.e);
        }
    },
    TraceR: function () {
        var a = [];
        var d = {};
        for (var i = 0; i < KB.memoryStep.length; i++) {
            var need = KB.memoryStep[i];
            d["s" + i.toString()] = {
                subGoal: need.subGoal ? need.subGoal : undefined,
                activeRule: need.activeRules[0] ? need.activeRules[0].number : [],
                steckGoals: need.steckGoals ? need.steckGoals : undefined,
                rule: need.rule.length > 0 ? need.rule : [],
                memory: need.memory[0] ? need.memory[0] : [],
            };
        }
        d.firstMemory = KB.firstMemory.toString();
        return JSON.stringify(d);
    },
    TraceF: function () {
        var a = [];
        var d = {};
        for (var i = 0; i < KB.memoryStep.length; i++) {
            var need = KB.memoryStep[i];
            d["s" + i.toString()] = {
                activeRule: need.activeRules[0] ? need.activeRules[0].number : [],
                rule: need.rule.length > 0 ? need.rule : [],
                memory: need.memory[0] ? need.memory[0] : [],
            };
        }
        d.firstMemory = KB.firstMemory.toString();
        return JSON.stringify(d);
    },
    p2s: function (obj) {
        $.post(
            obj.url,
            {
                name: obj.name ? obj.name : "user",
                trace: obj.end == "yes" ? this.TraceF() : "null",
                id: obj.id,
                end: obj.end,
                e: obj.e ? obj.e : "null",
            },
            this.completeAjax
        );
    },
    completeAjax: function (data) {
        $.jGrowl(data, 3000);
    },
    hideWin: function () {
        $("#select_div").fadeOut();
        $("#select_div_msg").slideUp();
    },
};
