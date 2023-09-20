### Programın amacı : 
Bir vsam dosyası oluşturup buna update delete write ve read operasyonu uygulamak ve sub programlarla çalışmak
___
### Nasıl çalıştırılır: 
İlk olarak RECAP90.JCL çalıştırılıp QSAM.AA QSAM.BB QSAM.KEY ve VSAM.AA oluşturulur.
İkinci olarak RECAP51.JCL çalıştırılır.Bu bir sub programdır ve main programın çalıştırılabilmesi için LOAD içine RECAP51 modulünü oluşturur.
Son aşamada RECAP50.JCL çalıştırılır.Bu main programdır.İşlem diğer iki işleme göre daha uzun sürer.
___
### Çalışma Mantığı: 
**RECAP90.JCL**

Kaynaklar klasöründeki ekran resmindeki gibi bir dataset oluşturmamız isteniyor SORT200 işlemi ile sort ile sıralı olarak aldığımız kayıtları QSAM.AA dosyasına tarih formatını julian çevirerek yazıyoruz. SORT400 işlemi ile ID kısmını COMP-3 formatı ile sıkıştırarak 3 byte, Doviz kısmısını COMP formatında sıkıştırarak 2 byte,isim ve soyisim kısmanı sıkıştırmadan direk alıyoruz,tarih kısmını COMP-3 formatında sıkıştırarak 4 byte ve doviz kısmınıda COMP-3 formatında sıkıştırarak 8 byte düşürüyoruz.QSAM.AA da toplam 60 byte olan satır uzunluğumuzu 47 byte düşürerek QSAM.BB dosyamıza yazıyoruz.SORT600 işleminde main programımıza göndereceğimiz isteklerimiz için QSAM.KEY dosyamızı oluşturuyoruz.En son işlem VSAM.AA dosyamızı oluşturup QSAM.BB dosyalarımızı VSAM.AA ya kopyalıyoruz.VSAM key için 5 byte olan ama sıkıştırdığımız için 3 byte düşen ID kısmını seçiyoruz.


**RECAP50**

Bu program main programıdır.WORKING-STORAGE SECTION da tanımlanan WW-SEND-AREA sub programla haberleşme için ortak kullanılacak alandır.Bu alanda main den sub göndermek için uygulancak operasyonu tanımlamak için belirtilecek WW-SELECT-MODE ve uygulanacak ID belirlemek için WW-INP-IDX-FILE-ID kısmı tanımlanır.WW-REPORT kısmıda sub programdan main programa gönderilen işlemin gerçekleşip gerçekleşmediği belirlemek için log kaydı oluşturup göndermesi için tanımlanmıştır.Procedure Dıvısıon ilk olarak input output file açar ve doğru açılıp açılmadığını kontrol eder.Yanlış açılmışsa programı sonlandırır.Doğru açılmışsa Read Action fonksiyonuna yönlendirilir.Read Action input file olan QSAM.KEY dosyasını satır satır okur ve en son satırda INPUT-FILE-EOF değişkenini setler ve bu sayede döngüyü bitirir.Döngü içinde QSAM.KEY in ilk karakterini WW-SELECT-MODE değişkenine atar.QSAM.KEY in diğer karafterleri alfanumerik olduğu için önce WS-INP-FILE-ID kısmına atar ve FUNCTION NUMVAL fonksiyonunu kullanarak sayı formatına dönüştürüp WW-INP-IDX-FILE-ID değişkenine atar.Bu işlemler sonunda sub programa göndermek için WW-SEND-AREA kısmını hazırlamış oluruz. ve  CALL WK-SUB-PROG USING WW-SEND-AREA kodunu kullanarak sub programını çalıştırırız.Sub programı gönderdiğimiz promta göre bize WW-REPORT kısmında bir log kaydı düzenleyip işini bitirir.Gelen logu OUT file yazar ve ana programımızı bitirmiş oluruz.

**RECAP51**

Bu program alt programdır.Burda ilk olarak VSAM dosyasını I-O olarak açıp doğru açılıp açılmadığını kontrol ediyoruz. Sonra Read Action fonksiyonuna yönlendiriyoruz. Read Action main programından gelen LS-SELECT-MODE değişkenini ilk olarak kontrol eder "R-W-U-D" kısımlarından birine uymuyorsa log dosyasını HATALI SECİM MODU olarak düzenler ve programı bitirir.Eğer LS-SELECT-MODE uygun bir karakter olarak gelmişse EVALUATE komutu ili ilgili fonksiyonuna yönlendirilir.
VSAM dosyasında 4 temel işlem gerçekleştirmemiz isteniyor.
1. READ
2. WRITE
3. DELETE
4. UPDATE

_H310-READ-FUNCTION_ 

İlk olarak fonksiyonumuzu H010-CHECK-MEMBER fonksiyonuna yönlendirilir. H010-CHECK-MEMBER fonksiyonu main den gelen ID yi VSAM içindeki IDX-FILE-ID taşır ve READ komutu ile VSAM o idnin olup olmadığını kontrol eder.Eğer WSAM da mevcutsa WS-CHECK değişkenini 1 e setler eğer VSAM da o id yoksa WS-CHECK değişkenini 0 a setler. Program READ-FUNCTION kısmına geri döner. WS-CHECK eğer 1 se kayıt VSAM da mevcuttur ve okunabilir olduğu için log kaydını istenilen formatta düzenler ve programı bitirir. Eğer WS-CHECK 0 sa aranan kayıt VSAM da yoktur bunun için READ işlemi gerçekleşemez log kaydı istenilen formatta düzenlenip program bitirlir.

_H320-WRITE-FUNCTION_ 

Bizden istenen VSAM a yeni bir kayıt eklememizdir. İlk olarak H010-CHECK-MEMBER fonksiyonu ile ID nin VSAM içinde olup olmadığını kontrol ederiz.Eğer varsa üstüne yazma tarzı bir hata olmaması için gerekli log kaydını düzenler ve fonksiyonu bitirilir.Eğer yoksa default olarak tanımlanan özellikler IDX file değişkenlerine taşınır ve WRITE ile VSAM içine yeni kayıt yazılır. Daha sonra invalid key ile WRITE işlemi kontrol edilir bir hata oluşup oluşmama durumuna göre log kaydı düzenlenir ve program sonlandırılır.

_H330-DELETE-FUNCTION_ 

Bizden istenen VSAM da main programda gönderilen ID li kayıdın silinmesidir. İlk olarak H010-CHECK-MEMBER fonksiyonu ile ID nin VSAM içinde olup olmadığını kontrol ederiz. Eğer kayıt yoksa olmayan bir kayıdı silemicemiz için log kaydını düzenler ve programı bitiririz. Eğer kayıt varsa DELETE işlemi ile kaydı siler invalid key ile DELETE işlemi kontrol edilir bir hata oluşup oluşmama durumuna göre log kaydı düzenleniriz ve programı sonlandırılız.

_H340-UPDATE-FUNCTION_

Bizden istenen VSAM da main programda gönderile ID li kayıdın isminde boşluk varsa boşlukları kaldırmamız ve soyadındaki E harflerini I, A harflerinide E ye dönüştürmemiz.H010-CHECK-MEMBER fonksiyonu ile kaydın VSAM da mevcut olup olmadığını kontrol ederiz. Eğer ID deki kayıt VSAM yoksa log kaydını düzenler ve programı bitiriz. Eğer kayıt VSAM da mevcut ise H010-CHECK-MEMBER değişkenini oluşturur ve NULL karakter hatası ile karşılakmamak için içini boşluk ile dolduruz.WS-INDEX değişkeni ile VSAM da ilgili kayıdın isminin bütün harflerini tek tek gezer her karakteri WS-TEMP değişkenine atarız.Sonra WS-TEMP değişkeninin space olup olmadığını kontrol eder eğer boşluktan farklı bir karakterse geçici olarakoluşturduğumuz WS-NAME-STRING değişkenine sıralı olarak atarız.İşlem bittiğinde WS-NAME-STRING stringinde boşlukları kaldırılmış bir isim oluşturmuş oluruz ve bunu tekrar IDX-FILE-NAME bölümüne atarız sonra INSPECT komutu ile IDX-FILE-SURNAME de E harflerini I ya, A harflerini E dönüştürürüz.En son işlem olarak REWRITE komutu ile düzenlediğimiz kaydı tekrar üzerine yazmayı deneriz. İşlem basaşarılı olup olmadığını kontrol eder gerekli log kaydını oluşturur ve programı bitiriz.


