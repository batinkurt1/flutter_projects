import "package:flutter/material.dart";

class CustomerMain extends StatefulWidget {
  @override
  _CustomerMainState createState() => _CustomerMainState();
}

class _CustomerMainState extends State<CustomerMain> {
  void _selectPage(int index) {
    setState(() {
      if (index==0){
        Navigator.of(context)
        .pushReplacementNamed("/shipment");}
        if (index==1){Navigator.of(context)
        .pushReplacementNamed("/allshipments");}
    });
  }
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              child: Icon(
                Icons.motorcycle,
                size: 75,
              ),
              width: 100,
            ),
            SizedBox(
              child: Text(
                "Gönder | Hemen Gelsin uygulamasına hoşgeldiniz! Şehir içi kurye teslimat işlemlerinizi aşağıda bulunan Teslimat Başlat butonundan kolayca ayarlayabilir, aktif teslimat işlemlerinizi Teslimatlarımı Görüntüle butonundan kolayca takip edebilirsiniz.",
                style: TextStyle(fontSize: 18),
              ),
              width: 230,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        SizedBox(
            child: ElevatedButton(
                onPressed:() {_selectPage(0);},
                child: Padding(
                  child: Text("Teslimat Başlat",style: TextStyle(fontSize: 16),),
                  padding: EdgeInsets.all(30),
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )))),
            width: MediaQuery.of(context).size.width * 3 / 4),
        SizedBox(
            child: ElevatedButton(
                onPressed:() {_selectPage(1);},
                child: Padding(
                  child: Text("Teslimatlarımı Görüntüle",style: TextStyle(fontSize: 16),),
                  padding: EdgeInsets.all(30),
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )))),
            width: MediaQuery.of(context).size.width * 3 / 4)
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}
