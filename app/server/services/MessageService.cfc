/**
 * Created with IntelliJ IDEA.
 * User: jason
 * Date: 12/3/13
 * Time: 6:10 PM
 * To change this template use File | Settings | File Templates.
*/
component {

    variables.gateway = "";

    public any function init() {
        return this;
    }

    public any function getMessageGateway() {
        return variables.gateway;
    }

    public void function setMessageGateway(gateway) {
        variables.gateway = arguments.gateway;
    }

    public Array function getAllMessages() {
        var messages = this.getMessageGateway().getAllMessages();
        writeDump(serializeJSON(messages));abort;
        return messages;
    }

}
