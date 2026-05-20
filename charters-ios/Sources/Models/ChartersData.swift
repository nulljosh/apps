import Foundation

struct Article: Identifiable {
    let id = UUID()
    let ref: String
    let title: String
    let tags: [String]
    let text: String
}

struct ConstitutionalDoc: Identifiable {
    let id: String
    let title: String
    let year: Int
    let parent: String
    let articles: [Article]
}

struct Country: Identifiable {
    let id: String
    let name: String
    let region: String
    let docs: [ConstitutionalDoc]

    var allArticles: [Article] { docs.flatMap(\.articles) }
    var allTags: Set<String> { Set(allArticles.flatMap(\.tags)) }
}

let chartersData: [Country] = [
    Country(id: "CA", name: "Canada", region: "North America", docs: [
        ConstitutionalDoc(id: "charter", title: "Canadian Charter of Rights and Freedoms", year: 1982, parent: "Constitution Act, 1982", articles: [
            Article(ref: "Section 2", title: "Fundamental Freedoms", tags: ["civil","political"], text: "Everyone has the following fundamental freedoms: (a) freedom of conscience and religion; (b) freedom of thought, belief, opinion and expression, including freedom of the press; (c) freedom of peaceful assembly; and (d) freedom of association."),
            Article(ref: "Section 7", title: "Life, Liberty and Security", tags: ["civil"], text: "Everyone has the right to life, liberty and security of the person and the right not to be deprived thereof except in accordance with the principles of fundamental justice."),
            Article(ref: "Section 8", title: "Search and Seizure", tags: ["civil"], text: "Everyone has the right to be secure against unreasonable search or seizure."),
            Article(ref: "Section 9", title: "Arbitrary Detention", tags: ["civil"], text: "Everyone has the right not to be arbitrarily detained or imprisoned."),
            Article(ref: "Section 12", title: "Cruel and Unusual Treatment", tags: ["civil"], text: "Everyone has the right not to be subjected to any cruel and unusual treatment or punishment."),
            Article(ref: "Section 15", title: "Equality Rights", tags: ["civil","political"], text: "Every individual is equal before and under the law and has the right to equal protection and benefit of the law without discrimination based on race, national or ethnic origin, colour, religion, sex, age or mental or physical disability."),
        ]),
        ConstitutionalDoc(id: "const1867", title: "Constitution Act", year: 1867, parent: "British North America Acts", articles: [
            Article(ref: "Section 91", title: "Federal Legislative Powers", tags: ["political"], text: "It shall be lawful for the Queen to make Laws for the Peace, Order, and good Government of Canada, in relation to all Matters not coming within the Classes of Subjects assigned exclusively to the Legislatures of the Provinces."),
            Article(ref: "Section 133", title: "Use of English and French", tags: ["cultural"], text: "Either the English or the French Language may be used by any Person in the Debates of the Houses of the Parliament of Canada and of the Houses of the Legislature of Quebec."),
        ]),
    ]),
    Country(id: "US", name: "United States", region: "North America", docs: [
        ConstitutionalDoc(id: "amendments", title: "Bill of Rights and Amendments", year: 1791, parent: "United States Constitution (1787)", articles: [
            Article(ref: "1st Amendment", title: "Religion, Speech, Press, Assembly", tags: ["civil","political"], text: "Congress shall make no law respecting an establishment of religion, or prohibiting the free exercise thereof; or abridging the freedom of speech, or of the press; or the right of the people peaceably to assemble, and to petition the Government for a redress of grievances."),
            Article(ref: "4th Amendment", title: "Search and Seizure", tags: ["civil"], text: "The right of the people to be secure in their persons, houses, papers, and effects, against unreasonable searches and seizures, shall not be violated, and no Warrants shall issue, but upon probable cause."),
            Article(ref: "5th Amendment", title: "Due Process, Self-Incrimination", tags: ["civil"], text: "No person shall be held to answer for a capital crime unless on indictment of a Grand Jury; nor shall any person be subject for the same offence to be twice put in jeopardy; nor shall be compelled in any criminal case to be a witness against himself; nor be deprived of life, liberty, or property, without due process of law."),
            Article(ref: "14th Amendment", title: "Equal Protection and Due Process", tags: ["civil","political"], text: "All persons born or naturalized in the United States are citizens. No State shall make or enforce any law which shall abridge the privileges or immunities of citizens; nor shall any State deprive any person of life, liberty, or property, without due process of law; nor deny to any person within its jurisdiction the equal protection of the laws."),
            Article(ref: "19th Amendment", title: "Women's Suffrage", tags: ["political"], text: "The right of citizens of the United States to vote shall not be denied or abridged by the United States or by any State on account of sex."),
        ]),
    ]),
    Country(id: "DE", name: "Germany", region: "Europe", docs: [
        ConstitutionalDoc(id: "gg", title: "Basic Law (Grundgesetz)", year: 1949, parent: "Federal Republic of Germany", articles: [
            Article(ref: "Article 1", title: "Human Dignity", tags: ["civil"], text: "Human dignity shall be inviolable. To respect and protect it shall be the duty of all state authority."),
            Article(ref: "Article 3", title: "Equality before the Law", tags: ["civil"], text: "All persons shall be equal before the law. Men and women shall have equal rights. No person shall be favoured or disfavoured because of sex, parentage, race, language, homeland and origin, faith, or religious or political opinions."),
            Article(ref: "Article 5", title: "Freedom of Expression and Press", tags: ["civil","political"], text: "Every person shall have the right freely to express and disseminate his opinions in speech, writing, and pictures. Freedom of the press and freedom of reporting by means of broadcasts and films shall be guaranteed."),
            Article(ref: "Article 8", title: "Freedom of Assembly", tags: ["civil","political"], text: "All Germans shall have the right to assemble peacefully and unarmed without prior notification or permission."),
            Article(ref: "Article 16a", title: "Right of Asylum", tags: ["civil"], text: "Persons persecuted on political grounds shall have the right of asylum."),
        ]),
    ]),
    Country(id: "GB", name: "United Kingdom", region: "Europe", docs: [
        ConstitutionalDoc(id: "hra", title: "Human Rights Act", year: 1998, parent: "European Convention on Human Rights (incorporated)", articles: [
            Article(ref: "Article 5", title: "Right to Liberty", tags: ["civil"], text: "Everyone has the right to liberty and security of person. No one shall be deprived of his liberty save in specific lawful cases such as lawful detention after conviction or lawful arrest."),
            Article(ref: "Article 8", title: "Right to Privacy", tags: ["civil"], text: "Everyone has the right to respect for his private and family life, his home and his correspondence."),
            Article(ref: "Article 10", title: "Freedom of Expression", tags: ["civil","political"], text: "Everyone has the right to freedom of expression. This right shall include freedom to hold opinions and to receive and impart information and ideas without interference by public authority."),
            Article(ref: "Article 14", title: "Prohibition of Discrimination", tags: ["civil"], text: "The enjoyment of the rights and freedoms set forth in this Convention shall be secured without discrimination on any ground such as sex, race, colour, language, religion, political or other opinion, national or social origin, property, birth or other status."),
        ]),
    ]),
    Country(id: "ZA", name: "South Africa", region: "Africa", docs: [
        ConstitutionalDoc(id: "bor96", title: "Bill of Rights — Chapter 2", year: 1996, parent: "Constitution of the Republic of South Africa", articles: [
            Article(ref: "Section 9", title: "Equality", tags: ["civil"], text: "Everyone is equal before the law and has the right to equal protection and benefit of the law without discrimination on grounds including race, gender, sex, ethnic origin, colour, sexual orientation, age, disability, religion, culture, language and birth."),
            Article(ref: "Section 10", title: "Human Dignity", tags: ["civil"], text: "Everyone has inherent dignity and the right to have their dignity respected and protected."),
            Article(ref: "Section 26", title: "Access to Housing", tags: ["social"], text: "Everyone has the right to have access to adequate housing."),
            Article(ref: "Section 27", title: "Health Care, Food, Water and Social Security", tags: ["social"], text: "Everyone has the right to have access to health care services, sufficient food and water, and social security."),
            Article(ref: "Section 29", title: "Education", tags: ["social","cultural"], text: "Everyone has the right to a basic education and to receive education in the official language or languages of their choice where reasonably practicable."),
        ]),
    ]),
]
