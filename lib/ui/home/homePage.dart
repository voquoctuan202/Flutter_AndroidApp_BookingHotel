import 'package:ct484_project/ui/hotel/hotelsPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}): super(key:key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameCity = TextEditingController();
 
  String valueChoose ="Phòng 1 giường 2 người";
  List listItem =[
    "Phòng 1 giường 2 người",
    "Phòng 2 giường 4 người",
    "Phòng 3 người 6 người",
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      
      appBar: AppBar(
        backgroundColor:Color.fromARGB(255, 3, 9, 75) ,
        title: const Center(
          child: Text("Trang chủ", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),),
        ),
      ),
      
      body:  _pageHome(),
      
    );
  }
  Widget _pageHome(){
    
    return Padding(

      padding: const EdgeInsets.only(left: 28, right: 28),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text("Tìm phòng", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black), ),
            const SizedBox(height: 8),
            _inputField("Nhập tên thành phố ...", nameCity),
           
            const SizedBox(height: 10),
            _searchBtn(),
            const SizedBox(height: 10),
            ListCity()
            

          ], 
        ),
      
    );
  }


  Widget _inputField(String hintText, TextEditingController controller,{isPassword = false}){
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0))
    );
    return TextField(
      
      style: const TextStyle(color: Color.fromARGB(255, 7, 0, 0),fontSize: 15),
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w200,),
        enabledBorder: border,
        focusedBorder: border, 
        
      ),
      obscureText: isPassword,
    );
  }
  
  

  Widget _searchBtn(){
    return ElevatedButton(
      onPressed: (){
       nameCity.text != "" ?
          Navigator.of(context).pushNamed(HotelsPage.routeName, arguments: removeVietnameseDiacritics( nameCity.text))
          : ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng nhập tên thành phố')));
          
        
        
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 3, 9, 75),
        shape: const StadiumBorder(),
        primary: Color.fromARGB(255, 228, 226, 226),
        onPrimary: Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.symmetric(vertical: 10)
      ) , 
      child: const SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tìm phòng",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(width: 8,),
            Icon(
              Icons.search
            ),
          ],
        )
      ),
    );
  }

  Widget ListCity(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Thành phố", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 15,),
          Container(
            height: 200,
            child: ListView(
              reverse: true,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                
                CityCard('assets/NhaTrangCity.jpg', "Nha Trang"),
                CityCard('assets/PhuQuocCity.jpg', "Phú Quốc"),
                CityCard('assets/CanThoCity.jpg', "Cần Thơ"),
                CityCard('assets/VungTauCity.jpg',"Vũng Tàu"),
                CityCard('assets/HoChiMinhCity.jpg', "TPHCM"),
              
              ],
            ),
          )
        ],
      );
    
  }

  Widget CityCard(image,name){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(HotelsPage.routeName, arguments: removeVietnameseDiacritics(name));
      },
      child: AspectRatio(
        aspectRatio: 2/3,
        child: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(77, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(image)
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                stops: [0.1,0.9], 
                colors: [
                  Colors.black.withOpacity(.8),
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              alignment: Alignment.bottomCenter,
              child: Text(name, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),),
            ),
            
          ),
        ),
        
        ),
    );
  }

  String removeVietnameseDiacritics(String input) {
  String output = input.toLowerCase();
  const Map<String, String> diacriticsMap = {
    'á': 'a', 'à': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
    'ă': 'a', 'ắ': 'a', 'ằ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
    'â': 'a', 'ấ': 'a', 'ầ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
    'đ': 'd',
    'é': 'e', 'è': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
    'ê': 'e', 'ế': 'e', 'ề': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
    'í': 'i', 'ì': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
    'ó': 'o', 'ò': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
    'ô': 'o', 'ố': 'o', 'ồ': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
    'ơ': 'o', 'ớ': 'o', 'ờ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
    'ú': 'u', 'ù': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
    'ư': 'u', 'ứ': 'u', 'ừ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
    'ý': 'y', 'ỳ': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
  };

  diacriticsMap.forEach((diacritic, char) {
    output = output.replaceAll(diacritic, char);
  });

  return output;
}

}