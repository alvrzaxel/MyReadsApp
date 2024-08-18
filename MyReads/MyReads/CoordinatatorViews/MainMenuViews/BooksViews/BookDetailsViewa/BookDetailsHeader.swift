//
//  BookDetailsHeader.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 30/7/24.
//

import SwiftUI

struct BookDetailsHeader: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Binding var book: UserBookModel
    @Binding var bookStatus: BookStatus
    var body: some View {
        VStack {
            HStack(alignment: .center ,spacing: 20) {
                BookDetailsCover(book: book)
                BookDetailsTitle(book: book)
                Spacer()
            }
            
            BookDetailsResume(userProfileViewModel: userProfileViewModel, book: $book, bookStatus: $bookStatus)
            
        }
        .frame(maxWidth: .infinity, maxHeight: 430)
   
    }
}

struct BookDetailsResume: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Binding var book: UserBookModel
    @Binding var bookStatus: BookStatus
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.black.opacity(0.15))
            .blur(radius: 1)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding(.horizontal)
            .padding(.top)
            .overlay {
                
                VStack(spacing: 12) {
                    Spacer()
                    HStack(alignment: .center) {
                        
                        Spacer(minLength: 0)
                        VStack {
                            Text(String(book.myRating)).font(.system(size: 18, weight: .semibold))
                            Text("My Rating".uppercased()).font(.system(size: 8, weight: .semibold))
                        }
                        Spacer(minLength: 0)
                        
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.colorbackground1)
                            .frame(width: 1)
                            .opacity(0.2)
                        
                        Spacer(minLength: 0)
                        VStack {
                            Text(String(book.pageCount ?? 0)).font(.system(size: 18, weight: .semibold))
                            Text("Pages".uppercased()).font(.system(size: 8, weight: .semibold))
                        }

                        Spacer(minLength: 0)
                        
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.colorbackground1)
                            .frame(width: 1)
                            .opacity(0.2)
                        
                        Spacer(minLength: 0)
                        VStack {
                            Text(book.language?.uppercased() ?? "UNK").font(.system(size: 18, weight: .semibold))
                            Text("language".uppercased()).font(.system(size: 8, weight: .semibold))
                        }
                        
                        Spacer(minLength: 0)
                    }
                    
                    .frame(maxHeight: 40)
                    .foregroundStyle(.white.opacity(0.8))
                    
                    BookDetailsActions(userProfileViewModel: userProfileViewModel, book: $book, bookStatus: $bookStatus)
                }
                .frame(maxHeight: 100)
                .padding()
            }

    }
}


struct BookDetailsActions: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Binding var book: UserBookModel
    @Binding var bookStatus: BookStatus
    
    var body: some View {
        VStack(spacing: 1) {
            
            RoundedRectangle(cornerRadius: 25)
                .fill(.colorbackground1)
                .frame(height: 1)
                .opacity(0.2)
            
            HStack(alignment: .center, spacing: 5) {
                Spacer(minLength: 0)
                
                BookDetailsStatus(userProfileViewModel: userProfileViewModel, book: $book, bookStatus: $bookStatus)
                
                BookDetailsMenu(userProfileViewModel: userProfileViewModel, book: $book, bookStatus: $bookStatus)
            }
        }
        .padding(.horizontal, 10)
    }
}



struct BookDetailsCover: View {
    let book: UserBookModel
    var body: some View {
        VStack {
            if let imageUrl = book.imageLinks?.thumbnail {
                AsyncImageView(urlString: imageUrl)
                    .scaledToFit()
                    .frame(maxWidth: 110, maxHeight: 160)
                    .clipped()
            } else {
                Rectangle()
                    .scaledToFill()
                    .frame(maxWidth: 110, maxHeight: 160)
                    .clipped()
                    .cornerRadius(10)
                    .foregroundStyle(.textQuaternary).opacity(0.5)
                    .overlay {
                        Text("No image available").foregroundStyle(.textTerciary).opacity(0.5)
                    }
            }
        }
        .padding(.leading, 16)
    }
}

struct BookDetailsTitle: View {
    let book: UserBookModel
    var body: some View {
        VStack(alignment: .leading ,spacing: 5) {
            Spacer()
            HStack {
                Text(book.title).font(.system(size: 22)).foregroundStyle(.white)
                
            }
            
            HStack {
                if let authors = book.authors, !authors.isEmpty {
                    Text("by \(authors.joined(separator: ", "))")
                } else {
                    Text("No authors available")
                }
                
            }.foregroundStyle(.white).font(.system(size: 12)).italic().padding(.leading, 5)
            
            HStack {
                if let genre = book.categories, !genre.isEmpty {
                    Text("#").foregroundStyle(.customOrange7) +
                    Text("\(genre.joined(separator: " #"))")
                } else {
                    Text("#") +
                    Text("NonGenre")
                    
                }
            }.font(.system(size: 18)).italic().foregroundStyle(.primary.opacity(0.6)).padding(.top, 10)
            Spacer()
        }
        .frame(maxHeight: 200)
    }
}

struct BookDetailsMenu: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Binding var book: UserBookModel
    @Binding var bookStatus: BookStatus
    
    var body: some View {
        VStack {
            Menu {
                Button(action: {
                    userProfileViewModel.addBook(userBook: book, status: .read)
                    bookStatus = .read
                    
                }, label: {
                    Text("Read").font(.footnote)
                })
                
                Button(action: {
                    userProfileViewModel.addBook(userBook: book, status: .wantToRead)
                    bookStatus = .wantToRead
                }, label: {
                    Text("Want to read").font(.footnote)
                })
                
                Button(action: {
                    userProfileViewModel.addBook(userBook: book, status: .currentlyReading)
                    bookStatus = .currentlyReading
                }, label: {
                    Text("Currently Reading").font(.footnote)
                })
                
                Divider()
                
                Button(role: .destructive) {
                    userProfileViewModel.removeBook(bookID: book.id)
                    bookStatus = .unkenow
                } label: {
                    Text("Delete").font(.footnote)
                }
                .disabled(bookStatus == .unkenow)
                
                
            } label: {
                Button{
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .padding(16)
                }
                .font(.system(size: 36, weight: .regular))
                .foregroundStyle(.colortext14)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct BookDetailsStatus: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Binding var book: UserBookModel
    @Binding var bookStatus: BookStatus

    var body: some View {
        HStack {
            switch bookStatus {
            case .unkenow:
                Button(action: {
                    withAnimation(.bouncy) {
                        userProfileViewModel.addBook(userBook: book, status: .wantToRead)
                        bookStatus = .wantToRead
                    }
                }) {
                    Label("Want to read", systemImage: "plus")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(5)
                        .padding(.horizontal, 5)
                        .background(.colorbackground9.opacity(0.4), in: RoundedRectangle(cornerRadius: 6))
                }
                .foregroundStyle(.colortext14)
                
            case .wantToRead:
                statusLabel("Want to read", backgroundColor: .green)
                
            case .read:
                statusLabel("Read", backgroundColor: .colorAccentOrange)
                
            case .currentlyReading:
                statusLabel("Currently reading", backgroundColor: .yellow)
            }
        }
        .font(.system(size: 16, weight: .regular))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func statusLabel(_ text: String, backgroundColor: Color) -> some View {
        Text(text)
            .foregroundStyle(.colortext14)
            .font(.system(size: 14, weight: .semibold))
            .padding(5)
            .padding(.horizontal, 5)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(backgroundColor.opacity(0.3))
                    .blur(radius: 2)
                    .frame(width: 140)
            }
    }
}


#Preview {
    BookDetailsHeader(userProfileViewModel: UserProfileViewModel(), book: .constant(UserBookModel(id: "234343", title: "Un lugar para Mungo", authors: ["Duglas Stuart"], publishedDate: "12", description: "REGRESA EL GANADOR DEL PREMIO BOOKER POR HISTORIA DE SHUGGIE BAIN « Un lugar para Mungo lo confirma: Douglas Stuart es un genio». Ron Charles, The Washington Post «Un puñetazo directo al corazón». Publishers Weekly A sus quince años, Mungo, un adolescente con una sensibilidad diferente al resto de los chicos del vecindario, vive en un barrio obrero del Glasgow de la era post-Thatcher, en el seno de una familia protestante: sin padre, con una madre alcohólica y un hermano que representa todo lo que él odia. En un ambiente masculinizado, rodeado de paro y peleas callejeras, solo cuenta con el apoyo y el cuidado de su hermana, Jodie. Tras un altercado familiar, su madre decide enviar a Mungo de pesca con dos desconocidos de Alcohólicos Anónimos para que hagan de él un hombre de provecho. De camino a un lago del oeste de Escocia con esos extraños cuyas bromas de borrachosesconden un pasado turbio, Mungo solo piensa en regresar al lado de su amigo James, el único lugar donde ha descubierto que puede ser él mismo. Douglas Stuart nos acerca, con una prosa lírica y vívida, al peligroso primer amor entre dos adolescentes en esta lúcida y conmovedora historia sobre el sentido de la masculinidad y deldeber para con la familia, las violencias a las que se enfrentan las identidades queer y los riesgos de querer demasiado a alguien. Críticas: «Un lugar para Mungo lo confirma: Douglas Stuart es un genio [...] Es capaz de tensar las cuerdas del suspense a la vez que mantiene una asombrosa sensibilidad a la hora de explorar la mente confusa de este gentil adolescente que intenta entender su sexualidad» Ron Charles, The Washington Post «Una novela enorme [...] Sigue un arco dickensiano: un joven marginado, que desea un futuro mejor, se ve atrapado en un esquema de violencia y debe escoger entre la vida que quiere para él y la que se le presenta [...] Esta novela te corta y luego te venda». Hillary Kelly, Los Angeles Times «Una novela hermosa y sutil que te partirá el corazón [...] Es un testimonio del poder implacable que tiene Stuart como narrador». Maureen Corrigan, NPR's Fresh Air «Su escritura es bellísima, une lo desagradable y lo mundano en una sintonía maravillosa [...] La novela transmite un sonido envolvente del lugar gracias al ingenio y la musicalidad de sus diálogos». Yen Pham, New York Times Book Review «Lloré con Historia de Shuggie Bain y he llorado de nuevo con el final de Un lugar para Mungo. Si la primera obra de Stuart lo situó como una gran promesa, esta novela confirma su prodigioso talento». Alex Preston, The Guardian «Esta es una historia cruda, tierna y generosa sobre el amor y la supervivencia en circunstancias difíciles». People «El autor crea personajes tan vívidos, dilemas tan desgarradores y diálogos tan brillantes que todo te succiona como una aspiradora [...] Romántica, aterradora, brutal, tierna y, al final, furtivamente esperanzadora. ¡Qué escritor!». Kirkus Reviews (reseña destacada)", pagesRead: 0, pageCount: 34, categories: ["Fiction"], averageRating: 4.5, myRating: 4.5, language: "es", imageLinks: ImageLinks(smallThumbnail: "https://m.media-amazon.com/images/I/71TQ+LBCU4L._AC_UF894,1000_QL80_.jpg", thumbnail: "https://m.media-amazon.com/images/I/71TQ+LBCU4L._AC_UF894,1000_QL80_.jpg"), bookStatus: .unkenow)), bookStatus: .constant(.wantToRead))
}
