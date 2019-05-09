public with sharing class FileUploaderController {
    @AuraEnabled
    public static void uploadDocument(String files, String versionData,String parent_id) {
        //parentIds = getParentIds(LookupIdFields, RelatedIdFields, parent_id, objectApiName);
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
        conVer.PathOnClient = '/' + files; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = files.substringBeforeLast('.'); // Display name of the files
        conVer.VersionData = EncodingUtil.base64Decode(versionData);
        insert conVer;
        System.debug(conVer.Id);

        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        System.debug(conDoc);
        //Create ContentDocumentLink
        List<ContentDocumentLink> conDocLinks = new List<ContentDocumentLink>();
            ContentDocumentLink conDocLink = new ContentDocumentLink();
            conDocLink.ContentDocumentId = conDoc;
            conDocLink.LinkedEntityId = parent_id; 
            conDocLink.ShareType = 'I'; 
            conDocLink.Visibility = 'AllUsers'; 
            conDocLinks.add(conDocLink);
        insert conDocLinks;
    }
}
