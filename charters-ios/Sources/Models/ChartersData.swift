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
    Country(id: "FR", name: "France", region: "Europe", docs: [
        ConstitutionalDoc(id: "droits", title: "Declaration of the Rights of Man and of the Citizen", year: 1789, parent: "French Republic — Preamble to 1958 Constitution", articles: [
            Article(ref: "Article 1", title: "Liberty and Equality", tags: ["civil"], text: "Men are born and remain free and equal in rights. Social distinctions may be based only on considerations of the common good."),
            Article(ref: "Article 2", title: "Natural Rights", tags: ["civil"], text: "The goal of any political association is the conservation of the natural and imprescriptible rights of man. These rights are liberty, property, safety and resistance against oppression."),
            Article(ref: "Article 4", title: "Definition of Liberty", tags: ["civil"], text: "Liberty consists of being able to do anything that does not harm others: thus, the exercise of the natural rights of every man has no bounds other than those that guarantee other members of society the enjoyment of these same rights."),
            Article(ref: "Article 6", title: "Law as General Will", tags: ["political"], text: "The law is the expression of the general will. All citizens have the right to take part, personally or through their representatives, in its making. It must be the same for all, whether it protects or punishes."),
            Article(ref: "Article 11", title: "Free Communication of Ideas", tags: ["civil","political"], text: "The free communication of ideas and of opinions is one of the most precious rights of man. Any citizen may therefore speak, write and publish freely, except what is tantamount to the abuse of this liberty in the cases determined by law."),
            Article(ref: "Article 17", title: "Right of Property", tags: ["economic"], text: "Property being an inviolable and sacred right, no one may be deprived of it, unless legally established public necessity obviously requires it, and upon condition of a just and previously determined indemnity."),
        ]),
    ]),
    Country(id: "SE", name: "Sweden", region: "Europe", docs: [
        ConstitutionalDoc(id: "se74", title: "Instrument of Government", year: 1974, parent: "Swedish Fundamental Laws (Grundlagarna)", articles: [
            Article(ref: "Ch. 1, Art. 2", title: "Human Dignity and Social Rights", tags: ["civil","social"], text: "The public institutions shall promote the opportunity for all to attain participation and equality in society and for the rights of the child to be safeguarded. The public institutions shall combat discrimination of persons on grounds of gender, colour, national or ethnic origin, linguistic or religious affiliation, functional disability, sexual orientation, age or other circumstance affecting the individual."),
            Article(ref: "Ch. 2, Art. 1", title: "Freedom of Expression and Information", tags: ["civil","political"], text: "Every citizen is guaranteed freedom of expression — freedom to communicate information and to express thoughts, opinions and feelings in speech, writing, pictures or in any other manner; freedom of information, that is, freedom to obtain and receive information and otherwise to acquaint oneself with the utterances of others."),
            Article(ref: "Ch. 2, Art. 6", title: "Personal Integrity and Privacy", tags: ["civil"], text: "Every citizen is protected against physical violations. Every citizen is likewise protected against searches, house searches and other such invasions of personal privacy, and against surveillance and monitoring of mail or other confidential correspondence, telephone calls, and other confidential communications."),
            Article(ref: "Ch. 2, Art. 17", title: "Right to Assemble and Demonstrate", tags: ["civil","political"], text: "Every citizen has the right to organise or participate in demonstrations in a public place, and to organise or join in processions in a public place."),
        ]),
        ConstitutionalDoc(id: "freedompress", title: "Freedom of the Press Act", year: 1766, parent: "Swedish Fundamental Laws — world's oldest freedom of press law", articles: [
            Article(ref: "Ch. 1, Art. 1", title: "Freedom of the Press — 1766", tags: ["civil","political"], text: "In accordance with the principles of a free state of opinion, the right of every Swedish subject to publish written documents without prior restriction by a public authority is hereby established."),
        ]),
    ]),
    Country(id: "JP", name: "Japan", region: "Asia", docs: [
        ConstitutionalDoc(id: "jp46", title: "Constitution of Japan — Chapter III", year: 1946, parent: "Promulgated under Emperor Showa", articles: [
            Article(ref: "Article 11", title: "Fundamental Human Rights", tags: ["civil"], text: "The people shall not be prevented from enjoying any of the fundamental human rights. These fundamental human rights guaranteed to the people by this Constitution shall be conferred upon the people of this and future generations as eternal and inviolate rights."),
            Article(ref: "Article 13", title: "Right to Life, Liberty, Pursuit of Happiness", tags: ["civil"], text: "All of the people shall be respected as individuals. Their right to life, liberty, and the pursuit of happiness shall, to the extent that it does not interfere with the public welfare, be the supreme consideration in legislation and in other governmental affairs."),
            Article(ref: "Article 14", title: "Equality under the Law", tags: ["civil"], text: "All of the people are equal under the law and there shall be no discrimination in political, economic or social relations because of race, creed, sex, social status or family origin."),
            Article(ref: "Article 21", title: "Freedom of Assembly and Expression", tags: ["civil","political"], text: "Freedom of assembly and association as well as speech, press and all other forms of expression are guaranteed. No censorship shall be maintained, nor shall the secrecy of any means of communication be violated."),
            Article(ref: "Article 25", title: "Right to Minimum Living Standards", tags: ["social"], text: "All people shall have the right to maintain the minimum standards of wholesome and cultured living. In all spheres of life, the State shall use its endeavors for the promotion and extension of social welfare and security, and of public health."),
            Article(ref: "Article 28", title: "Right to Organize and Bargain", tags: ["economic"], text: "The right of workers to organize and to bargain and act collectively is guaranteed."),
        ]),
    ]),
    Country(id: "AU", name: "Australia", region: "Oceania", docs: [
        ConstitutionalDoc(id: "au01", title: "Australian Constitution", year: 1901, parent: "Commonwealth of Australia Constitution Act (UK)", articles: [
            Article(ref: "Section 80", title: "Trial by Jury", tags: ["civil"], text: "The trial on indictment of any offence against any law of the Commonwealth shall be by jury, and every such trial shall be held in the State where the offence was committed."),
            Article(ref: "Section 116", title: "No Established Religion", tags: ["civil"], text: "The Commonwealth shall not make any law for establishing any religion, or for imposing any religious observance, or for prohibiting the free exercise of any religion, and no religious test shall be required as a qualification for any office or public trust under the Commonwealth."),
            Article(ref: "Implied Right (1997)", title: "Freedom of Political Communication", tags: ["political"], text: "The Constitution contains an implied freedom of political communication, derived from the system of representative and responsible government it establishes. This prohibits laws that unduly burden freedom of communication on matters of government and politics."),
        ]),
    ]),
    Country(id: "NZ", name: "New Zealand", region: "Oceania", docs: [
        ConstitutionalDoc(id: "nzbor", title: "New Zealand Bill of Rights Act", year: 1990, parent: "New Zealand Statute", articles: [
            Article(ref: "Section 13", title: "Freedom of Thought, Conscience and Religion", tags: ["civil"], text: "Everyone has the right to freedom of thought, conscience, religion, and belief, including the right to adopt and hold opinions without interference."),
            Article(ref: "Section 14", title: "Freedom of Expression", tags: ["civil","political"], text: "Everyone has the right to freedom of expression, including the freedom to seek, receive, and impart information and opinions of any kind in any form."),
            Article(ref: "Section 19", title: "Freedom from Discrimination", tags: ["civil"], text: "Everyone has the right to freedom from discrimination on the grounds of colour, race, ethnic or national origins, sex, marital status, or religious belief."),
            Article(ref: "Section 22", title: "Right to Liberty", tags: ["civil"], text: "Everyone has the right not to be arbitrarily arrested or detained."),
        ]),
        ConstitutionalDoc(id: "nztreaty", title: "Treaty of Waitangi", year: 1840, parent: "Te Tiriti o Waitangi — foundational constitutional significance", articles: [
            Article(ref: "Article 2", title: "Rangatiratanga — Maori Self-Determination", tags: ["political","cultural"], text: "The Crown guarantees to the Chiefs and Tribes of New Zealand the full exclusive and undisturbed possession of their Lands and Estates, Forests, Fisheries and other properties which they may collectively or individually possess."),
            Article(ref: "Article 3", title: "Equal Rights of Citizenship", tags: ["civil"], text: "The Queen of England extends to the Natives of New Zealand Her royal protection and imparts to them all the Rights and Privileges of British Subjects."),
        ]),
    ]),
    Country(id: "EU", name: "European Union", region: "Europe (Supranational)", docs: [
        ConstitutionalDoc(id: "eu00", title: "Charter of Fundamental Rights of the EU", year: 2009, parent: "Treaty of Lisbon — legally binding since 2009", articles: [
            Article(ref: "Article 1", title: "Human Dignity", tags: ["civil"], text: "Human dignity is inviolable. It must be respected and protected."),
            Article(ref: "Article 2", title: "Right to Life", tags: ["civil"], text: "Everyone has the right to life. No one shall be condemned to the death penalty, or executed."),
            Article(ref: "Article 7", title: "Respect for Private and Family Life", tags: ["civil"], text: "Everyone has the right to respect for his or her private and family life, home and communications."),
            Article(ref: "Article 8", title: "Protection of Personal Data", tags: ["civil"], text: "Everyone has the right to the protection of personal data concerning him or her. Such data must be processed fairly for specified purposes and on the basis of the consent of the person concerned."),
            Article(ref: "Article 11", title: "Freedom of Expression and Information", tags: ["civil","political"], text: "Everyone has the right to freedom of expression. This right shall include freedom to hold opinions and to receive and impart information and ideas without interference by public authority. The freedom and pluralism of the media shall be respected."),
            Article(ref: "Article 21", title: "Non-discrimination", tags: ["civil"], text: "Any discrimination based on any ground such as sex, race, colour, ethnic or social origin, genetic features, language, religion or belief, political or any other opinion shall be prohibited."),
            Article(ref: "Article 31", title: "Fair and Just Working Conditions", tags: ["economic"], text: "Every worker has the right to working conditions which respect his or her health, safety and dignity, and to limitation of maximum working hours and an annual period of paid leave."),
        ]),
    ]),
    Country(id: "IN", name: "India", region: "Asia", docs: [
        ConstitutionalDoc(id: "in50", title: "Fundamental Rights — Part III", year: 1950, parent: "Constitution of India", articles: [
            Article(ref: "Article 14", title: "Equality before Law", tags: ["civil"], text: "The State shall not deny to any person equality before the law or the equal protection of the laws within the territory of India."),
            Article(ref: "Article 17", title: "Abolition of Untouchability", tags: ["civil"], text: "Untouchability is abolished and its practice in any form is forbidden. The enforcement of any disability arising out of Untouchability shall be an offence punishable in accordance with law."),
            Article(ref: "Article 19", title: "Six Fundamental Freedoms", tags: ["civil","political","economic"], text: "All citizens shall have the right to freedom of speech and expression; to assemble peaceably and without arms; to form associations or unions; to move freely throughout the territory of India; and to practise any profession, or to carry on any occupation, trade or business."),
            Article(ref: "Article 21", title: "Right to Life and Personal Liberty", tags: ["civil"], text: "No person shall be deprived of his life or personal liberty except according to procedure established by law."),
            Article(ref: "Article 21A", title: "Right to Education", tags: ["social"], text: "The State shall provide free and compulsory education to all children of the age of six to fourteen years. (86th Amendment, 2002)"),
            Article(ref: "Article 25", title: "Freedom of Conscience and Religion", tags: ["civil"], text: "Subject to public order, morality and health, all persons are equally entitled to freedom of conscience and the right freely to profess, practise and propagate religion."),
            Article(ref: "Article 29", title: "Protection of Minority Interests", tags: ["cultural"], text: "Any section of the citizens residing in the territory of India having a distinct language, script or culture of its own shall have the right to conserve the same."),
        ]),
    ]),
    Country(id: "MX", name: "Mexico", region: "North America", docs: [
        ConstitutionalDoc(id: "cpeum", title: "Political Constitution of the United Mexican States", year: 1917, parent: "Constitucion Politica de los Estados Unidos Mexicanos", articles: [
            Article(ref: "Article 1", title: "Human Rights and Their Guarantee", tags: ["civil"], text: "In the United Mexican States everyone will enjoy the human rights recognized in this Constitution and in the international human rights treaties. All authorities shall prevent, investigate, punish and remedy violations of human rights."),
            Article(ref: "Article 3", title: "Right to Education", tags: ["social","cultural"], text: "Every person has the right to receive education. Public education will be free, secular and compulsory. The State shall guarantee quality education, with equity, inclusion and intercultural excellence."),
            Article(ref: "Article 4", title: "Equality and Social Rights", tags: ["civil","social"], text: "Men and women are equal before the law. Everyone has the right to health protection. Every family has the right to enjoy decent and dignified housing. Every person has the right to food that is nutritious, sufficient and of quality."),
            Article(ref: "Article 6", title: "Freedom of Expression", tags: ["civil","political"], text: "The manifestation of ideas shall not be subject to any judicial or administrative investigation unless it attacks the morals of third parties or the rights of others. The right to free access to pluralistic and truthful information is guaranteed."),
            Article(ref: "Article 123", title: "Labour Rights", tags: ["economic"], text: "Every person has the right to dignified and socially useful work. The maximum duration of the work day shall be eight hours. Workers shall have the right to a minimum wage sufficient to satisfy the normal material, social and cultural needs."),
        ]),
    ]),
    Country(id: "KR", name: "South Korea", region: "Asia", docs: [
        ConstitutionalDoc(id: "kr48", title: "Constitution of the Republic of Korea", year: 1948, parent: "Current version amended 1987", articles: [
            Article(ref: "Article 10", title: "Human Dignity and Happiness", tags: ["civil"], text: "All citizens shall be assured of human worth and dignity and have the right to pursue happiness. It shall be the duty of the State to confirm and guarantee the fundamental and inviolable human rights of individuals."),
            Article(ref: "Article 11", title: "Equality", tags: ["civil"], text: "All citizens shall be equal before the law, and there shall be no discrimination in political, economic, social, or cultural life on account of sex, religion, or social status."),
            Article(ref: "Article 12", title: "Freedom and Security of Person", tags: ["civil"], text: "All citizens shall enjoy personal liberty. No person shall be arrested, detained, searched, seized or interrogated except as provided by Act and through lawful procedures."),
            Article(ref: "Article 21", title: "Freedom of Speech and Press", tags: ["civil","political"], text: "All citizens shall enjoy freedom of speech and the press, and freedom of assembly and association. Licensing or censorship of speech and the press shall not be recognized."),
            Article(ref: "Article 31", title: "Right to Education", tags: ["social"], text: "All citizens shall have an equal right to receive an education corresponding to their abilities."),
            Article(ref: "Article 32", title: "Right to Work", tags: ["economic"], text: "All citizens shall have the right to work. The State shall endeavor to promote the employment of workers and to guarantee optimum wages and shall enforce a minimum wage system."),
            Article(ref: "Article 34", title: "Human Dignity and Social Security", tags: ["social"], text: "All citizens shall be entitled to a life worthy of human beings. The State shall have the duty to endeavor to promote social security and welfare."),
        ]),
    ]),
    Country(id: "BR", name: "Brazil", region: "South America", docs: [
        ConstitutionalDoc(id: "br88", title: "Federal Constitution — Fundamental Rights", year: 1988, parent: "Constituicao da Republica Federativa do Brasil", articles: [
            Article(ref: "Art. 5 (caput)", title: "Equality and Legal Security", tags: ["civil"], text: "All persons are equal before the law, without any distinction whatsoever, Brazilians and foreigners residing in the country being ensured of inviolability of the right to life, to liberty, to equality, to security and to property."),
            Article(ref: "Art. 5, IV", title: "Freedom of Thought", tags: ["civil"], text: "Freedom of thought is assured, and anonymity is forbidden."),
            Article(ref: "Art. 5, IX", title: "Freedom of Expression and Artistic Activity", tags: ["civil"], text: "Expression of intellectual, artistic, scientific and communications activity is free, independently of censorship or licensing."),
            Article(ref: "Art. 6", title: "Social Rights", tags: ["social"], text: "The following are social rights: education, health, food, work, housing, transportation, leisure, security, social security, protection of motherhood and childhood, and assistance to the destitute."),
            Article(ref: "Art. 7", title: "Rights of Workers", tags: ["economic"], text: "The following are rights of urban and rural workers: employment protection against arbitrary dismissal; unemployment insurance; minimum wage; overtime pay; annual paid vacation; maternity and paternity leave."),
        ]),
    ]),
]
