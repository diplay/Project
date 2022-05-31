function buildNode(node) {
    let nodeElem = document.createElement("div");
    let nodeLabel = document.createElement("span");
    let nodeAction = document.createElement("a");
    let nodeDelete = document.createElement("a");
    nodeDelete.innerText = "Удалить";
    nodeDelete.href = "/component_elements/" + node.id + "/destroy";
    // nodeDelete.setAttribute("data-method", "delete");
    nodeAction.href = "/component_elements/" + node.id;
    nodeAction.innerText = "Редактировать";
    nodeLabel.innerText = node.name;
    if (node.is_multiple) {
        nodeLabel.innerText += ` (${node.tag} = {${node.tag}i}, i = 1..`;
        if (node.size === null || node.size === undefined) {
            nodeLabel.innerText += "n)";
        } else {
            nodeLabel.innerText += (node.size + 1).toString() + ")";
        }
    } else {
        nodeLabel.innerText += " (" + node.tag + ")";
    }
    let switcher = null;
    if (node.children.length) {
        nodeElem.style.position = "relative";
        switcher = document.createElement("span");
        switcher.style.padding = "10px";
        switcher.style.left = "-5px";
        switcher.style.top = "-15px";
        switcher.style.position = "absolute";
        switcher.innerHTML = "&#8964;";
        switcher.style.cursor = "pointer";
        nodeElem.appendChild(switcher);
    }
    nodeElem.appendChild(nodeLabel);
    nodeLabel.style.marginRight = "10px";
    nodeElem.appendChild(nodeAction);
    nodeAction.style.marginRight = "10px";
    nodeElem.appendChild(nodeDelete);
    nodeElem.style.paddingLeft = "30px";

    let sub = nodeElem.appendChild(document.createElement("div"));

    node.children.forEach((child) => {
        sub.appendChild(buildNode(child));
    });
    if (switcher) {
        switcher.onclick = () => {
            sub.style.display = sub.style.display != "none" ? "none" : "block";
        };
    }

    return nodeElem;
}
