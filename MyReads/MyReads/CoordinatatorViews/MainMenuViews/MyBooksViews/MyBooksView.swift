//
//  MyBooksView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 25/7/24.
//

import SwiftUI



struct MyBooksView: View {
    @Binding  var showChangeTheme: Bool
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State var selectedList: BookList = .wantToRead
    
    var body: some View {
        ZStack {
            Color.colorbackground1.ignoresSafeArea()
            
            VStack(spacing: 20) {
                if userProfileViewModel.shouldShowCurrentlyReadingView() {
                    CurrentlyView(userProfileViewModel: userProfileViewModel)
                }
                
                MyBooksPickerView(userProfileViewModel: userProfileViewModel, selectedList: $selectedList)
            }
            
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top) {
            CustomNavBarMyBooks(showChangeTheme: $showChangeTheme)
        }
    }
    
    
}




#Preview {
    let user = UserProfileViewModel()
    user.user.books.append(UserBookModel(id: "234343", title: "Un lugar para Mungo", authors: ["Duglas Stuart"], publishedDate: "12", description: "REGRESA EL GANADOR DEL PREMIO BOOKER POR HISTORIA DE SHUGGIE BAIN « Un lugar para Mungo lo confirma: Douglas Stuart es un genio». Ron Charles, The Washington Post «Un puñetazo directo al corazón». Publishers Weekly A sus quince años, Mungo, un adolescente con una sensibilidad diferente al resto de los chicos del vecindario, vive en un barrio obrero del Glasgow de la era post-Thatcher, en el seno de una familia protestante: sin padre, con una madre alcohólica y un hermano que representa todo lo que él odia. En un ambiente masculinizado, rodeado de paro y peleas callejeras, solo cuenta con el apoyo y el cuidado de su hermana, Jodie. Tras un altercado familiar, su madre decide enviar a Mungo de pesca con dos desconocidos de Alcohólicos Anónimos para que hagan de él un hombre de provecho. De camino a un lago del oeste de Escocia con esos extraños cuyas bromas de borrachosesconden un pasado turbio, Mungo solo piensa en regresar al lado de su amigo James, el único lugar donde ha descubierto que puede ser él mismo. Douglas Stuart nos acerca, con una prosa lírica y vívida, al peligroso primer amor entre dos adolescentes en esta lúcida y conmovedora historia sobre el sentido de la masculinidad y deldeber para con la familia, las violencias a las que se enfrentan las identidades queer y los riesgos de querer demasiado a alguien. Críticas: «Un lugar para Mungo lo confirma: Douglas Stuart es un genio [...] Es capaz de tensar las cuerdas del suspense a la vez que mantiene una asombrosa sensibilidad a la hora de explorar la mente confusa de este gentil adolescente que intenta entender su sexualidad» Ron Charles, The Washington Post «Una novela enorme [...] Sigue un arco dickensiano: un joven marginado, que desea un futuro mejor, se ve atrapado en un esquema de violencia y debe escoger entre la vida que quiere para él y la que se le presenta [...] Esta novela te corta y luego te venda». Hillary Kelly, Los Angeles Times «Una novela hermosa y sutil que te partirá el corazón [...] Es un testimonio del poder implacable que tiene Stuart como narrador». Maureen Corrigan, NPR's Fresh Air «Su escritura es bellísima, une lo desagradable y lo mundano en una sintonía maravillosa [...] La novela transmite un sonido envolvente del lugar gracias al ingenio y la musicalidad de sus diálogos». Yen Pham, New York Times Book Review «Lloré con Historia de Shuggie Bain y he llorado de nuevo con el final de Un lugar para Mungo. Si la primera obra de Stuart lo situó como una gran promesa, esta novela confirma su prodigioso talento». Alex Preston, The Guardian «Esta es una historia cruda, tierna y generosa sobre el amor y la supervivencia en circunstancias difíciles». People «El autor crea personajes tan vívidos, dilemas tan desgarradores y diálogos tan brillantes que todo te succiona como una aspiradora [...] Romántica, aterradora, brutal, tierna y, al final, furtivamente esperanzadora. ¡Qué escritor!». Kirkus Reviews (reseña destacada)", pagesRead: 10, pageCount: 300, categories: ["Fiction"], averageRating: 4.5, myRating: 4.5, language: "es", imageLinks: ImageLinks(smallThumbnail: "https://m.media-amazon.com/images/I/71TQ+LBCU4L._AC_UF894,1000_QL80_.jpg", thumbnail: "https://m.media-amazon.com/images/I/71TQ+LBCU4L._AC_UF894,1000_QL80_.jpg"), bookStatus: .currentlyReading))
    
    
    return MyBooksView(showChangeTheme: .constant(false), userProfileViewModel: user)
}
