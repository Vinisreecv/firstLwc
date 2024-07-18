public with sharing class productController {
    // @AuraEnabled(Cacheable = true)
    // public static List<Product2> retriveProducts() {
      
    //     List<Product2> lstProd = [SELECT  Id, Name, ProductCode FROM Product2 LIMIT 5];
    //     return lstProd; 
    // }
    // @AuraEnabled(Cacheable = true)
    // public static List<Product2> retriveProductList(String strProdName) {
    //     strProdName = '%' + strProdName + '%';
    //     List<Product2> lstProd = [SELECT  Id, Name, ProductCode FROM Product2 WHERE Name LIKE :strProdName];
    //     return lstProd; 
    // }

    @AuraEnabled(cacheable = true)
    public static list<Product2> productlist(string searchkey){
        string searchingnamelike = '%' + searchkey + '%';
return [Select Id,ProductCode,Name from Product2 where  name LIKE : searchingnamelike limit 5];
    }
}