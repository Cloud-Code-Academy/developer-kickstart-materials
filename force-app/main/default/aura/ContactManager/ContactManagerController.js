({
    doInit : function(component, event, helper) {
        helper.fetchContacts(component);
    },

    saveContact : function(component, event, helper) {
        helper.saveContact(component);
    }
})
