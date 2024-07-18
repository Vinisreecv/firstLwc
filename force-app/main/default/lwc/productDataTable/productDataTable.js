import { LightningElement,wire,track } from 'lwc';
import productlist from'@salesforce/apex/productController.productlist';
// import searchlist from'@salesforce/apex/productController.retriveProductList';
const columns=[{label:'Product id',fieldName:'Id'},
                {label:'Product CODE',fieldName:'ProductCode'},
                {label:'PRODUCT NAME',fieldName:'Name'}
]


export default class ProductDataTable extends LightningElement {

   /* datatable;
    @track columns=columns;
    error;
    @track searchData;
    @track strSearchProdName;
    @wire(productlist)
    producthandeler({data,error}){
        if(data){
        this.datatable=data;
        console.log(data);
        if(error){
            console.log(error);
            this.error = error;
            console.log(error);
            }
        }
        
    }

    handleProductName(event) {
        this.strSearchProdName = event.detail.value;
        searchlist({strProdName : this.strSearchProdName})
        .then(result => {
        this.searchData = result;
    })
}*/
searchkey = '';
columns=columns;
finaldatatable;
error;
hadleonchange(event){
    this.searchkey = event.target.value;
}

@wire(productlist,{searchkey:'$searchkey'})
producthandeler({data,error}){
    console.log('hello world data tablee search')
    if(data){
    this.finaldatatable = data;
    console.log('inside data');
    console.log(data);
    }
    else{
        console.log(error);
        this.error = error;
        console.log(error);
        }
}
}