({
    fetchContacts : function(component) {
        var action = component.get("c.getContacts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.contacts", response.getReturnValue());
            }
            // Error handling not added for brevity
        });
        $A.enqueueAction(action);
    },

    saveContact : function(component) {
        var action = component.get("c.saveContact");
        action.setParams({ contact: component.get("v.contact") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.fetchContacts(component); // Refresh the list
                component.set("v.contact", { 'sobjectType': 'Contact' }); // Reset the form
            }
            // Error handling not added for brevity
        });
        $A.enqueueAction(action);
    }
})
