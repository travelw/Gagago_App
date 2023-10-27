import 'package:get/get.dart';

class MultiLanguages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        //1).For English Language Translation
        'en_US': {
          'Welcome!': 'Welcome!',
          'Remember Me': 'Remember Me',
          'When you select common destinations and interests, you’ll see suggested connections.':
              'When you select common destinations and interests, you’ll see suggested connections.',
          'Forgot Password?': 'Forgot Password?',
          'Login': 'Login',
          "Don’t have an account? Sign Up": "Don’t have an account? Sign Up"
        },
        //2).For Portuguese Language Translation
        'pt_BR': {
          'Welcome!': 'Bem-vindo!',
          'Remember Me': 'Lembre de mim',
          'When you select common destinations and interests, you’ll see suggested connections.':
              'Ao selecionar destinos e interesses comuns, você verá perfis sugeridos para se conectar.',
          'Forgot Password?': 'Esqueceu a senha?',
          'Login': 'Conecte-se',
          "Don’t have an account? Sign Up": "Não tem uma conta?"
        },

        //3).For French Language Translation
        'fr_FR': {
          'Welcome!': 'Bienvenue!',
          'Remember Me': 'Se souvenir de moi',
          'When you select common destinations and interests, you’ll see suggested connections.':
              'En sélectionnant des destinations et des intérêts communs, des suggestions de connexions vous seront proposées.',
          'Forgot Password?': 'Mot de passe oublié?',
          'Login': 'Connexion',
          "Don’t have an account? Sign Up": "Vous n’avez pas de compte?",
          "Don’t have an account? Sign Up Sign Up": "Vous n’avez pas de compte? S’inscrire"
        },

        //4).For Hindi Language Translation
        'hi_IN': {
          //Login Screen
          'Welcome!': 'स्वागत!',
          'Remember Me': 'मुझे याद रखें',
          'When you select common destinations and interests, you’ll see suggested connections.':
              'जब आप सामान्य गंतव्यों और रुचियों का चयन करते हैं, तो आपको कनेक्ट करने के लिए सुझाई गई प्रोफ़ाइल दिखाई देंगी।',
          'Forgot Password?': 'पासवर्ड भूल गए?',
          'Login': 'लॉग इन करें',
          'Enter your email': 'अपना ईमेल दर्ज करें',
          'Password': 'पासवर्ड',
          'Please enter password': 'कृप्या पास्वर्ड भरो',
          'Don\'t have an Account?': 'खाता नहीं है??',
          ' Sign Up': ' साइन अप करें',
          'No Internet Available!!!!!': 'कोई इंटरनेट उपलब्ध नहीं!',
          'Loading...': 'लोड हो रहा है......',
          'Oops Error': 'उफ़ त्रुटि',
          'Something went wrong ': 'कुछ गलत हो गया',
          'Okay': 'ठीक',

          //For Forgot Password Screen
          'Enter your email for the verification process we will send 4 digits code': 'सत्यापन प्रक्रिया के लिए अपना ईमेल दर्ज करें हम 4 अंकों का कोड भेजेंगे',
          'Please enter email': 'कृपया ईमेल दर्ज करें',
          'Send': 'भेजना',

          //For Verify Your Profile Screen
          'Verify Your Profile': 'अपनी प्रोफ़ाइल सत्यापित करें',
          'Please enter the 4 digit code you received.': 'कृपया आपको प्राप्त 4 अंकों का कोड दर्ज करें',
          'Please enter verification code': 'कृपया सत्यापन कोड दर्ज करें',
          'Verify': 'सत्यापित करना',
          'Resend Code': 'पुन: कोड भेजे',

          //For Create Change Password Screen
          'Create New Password': 'नया पासवर्ड बनाएं',
          'Your new password must be different\n from previously used password': 'आपका नया पासवर्ड पहले इस्तेमाल किए गए पासवर्ड से अलग\n होना चाहिए',
          'New Password': 'नया पासवर्ड',
          'Please enter New Password': 'Por favor ingrese Nueva Coकृपया नया पासवर्ड दर्ज करें',
          'Must be at least 8 characters': 'कम से कम 8 अक्षर होने चाहिए',
          'confirm Password': 'पासवर्ड की पुष्टि कीजिये',
          'Please enter Confirm Password': 'कृपया पासवर्ड की पुष्टि करें दर्ज करें',
          'Both password must match': 'दोनों पासवर्ड का मिलान होना चाहिए',
          'Save': 'सहेजें',

          //For Password Reset Successfully Screen
          'Password Reset\n Successfully': 'पासवर्ड रीसेट\n सफलतापूर्वक',
          'You have successfully reset your password.\n Please use your new password when logging in.':
              'आपने अपना पासवर्ड सफलतापूर्वक रीसेट कर लिया है।\n लॉग इन करते समय कृपया अपने नए पासवर्ड का उपयोग करें।',
          'Please check your email for verification.': 'सत्यापन के लिए कृपया अपना ईमेल जांचें।',
          'Back To Login': 'लॉगिन पर वापस जाएं',
          'Get Started': 'शुरू हो जाओ',

          //2). Sign Up Module
          //For Sign Up Screen
          'Name': 'नाम',
          'Date Of Birth': 'जन्म की तारीख',
          'Email': 'ईमेल',
          'Confirm Password': 'पासवर्ड की पुष्टि कीजिये',
          'Please enter name': 'कृपया नाम दर्ज करें',
          'Please enter date of birth': 'कृपया जन्म तिथि दर्ज करें',
          'Please enter valid email': 'कृपया वैध ईमेल दर्ज़ करें',
          'Please enter confirm password': 'कृपया पासवर्ड की पुष्टि करें दर्ज करें',
          'Password and Confirm Password must match': 'पासवर्ड और कन्फर्म पासवर्ड का मिलान होना चाहिए',
          'Next': 'अगला',
          'Already have an account?': 'क्या आपके पास पहले से एक खाता मौजूद है?',

          //For Sign Up Preference Screen
          'Gender': 'लिंग',
          'Male': 'पुरुष',
          'Female': 'महिला',
          'Transgender': 'ट्रांसजेंडर',
          'Visible on profile': 'प्रोफ़ाइल पर दृश्यमान',
          'Sexual Orientation': 'यौन अभिविन्यास',
          'Straight': 'सीधा',
          'Bisexual': 'उभयलिंगी',
          'Lesbian': 'समलैंगिक',
          'Gay': 'समलैंगिक',

          //For Sign Up Travel Screen
          'Trip Style': 'ट्रिप स्टाइल',
          'Backpacking': 'बैकपैकिंग',
          'Mid-Range': 'मध्य स्तर',
          'Luxury': 'विलासिता',
          'Travelling within the next': 'अगले के भीतर यात्रा',
          '1-3 Months': '1-3 महीने',
          '3-6 Months': '3-6 महीने',
          '6-12 months': '6-12 महीने',
          'Destinations': 'स्थल',
          'Meet Now': 'अब मिलो',

          //For Destination Screen
          'Where do you want to go? Choose 4 destinations': 'आप कहाँ जाना चाहते हैं? 4 गंतव्य चुनें',
          'Choose 4 destinations': '4 गंतव्य चुनें',
        },

        //5).For Spanish Language Translation
        'es_ES': {
          //1). Login Module
          //Login Screen
          'Welcome!': '¡Bienvenidas!',
          'When you select common destinations and interests, you’ll see suggested connections.':
              'Cuando seleccione destinos e intereses comunes, verá perfiles sugeridos para conectarse.',
          'Enter your email': 'Introduce tu correo electrónico',
          'Password': 'Clave',
          'Please enter email': 'Por favor ingrese el correo electrónico',
          'Please enter password': 'Por favor, ingrese contraseña',
          'Remember Me': 'Recuérdame',
          'Forgot Password?': '¿Has olvidado tu contraseña?',
          'Login': 'Acceso',
          'Don\'t have an Account?': '¿No tienes una cuenta?',
          ' Sign Up': ' Inscribirse',
          'No Internet Available!!!!!': '¡No hay Internet disponible!',
          'Loading...': 'Cargando...',
          'Oops Error': 'Vaya error',
          'Something went wrong ': 'Algo salió mal',
          'Okay': 'De acuerdo',
          'Enter your email for the verification process we will send 4 digits code': 'Ingrese su correo electrónico para el proceso de verificación le enviaremos un código de 4 dígitos',
          'Send': 'Enviar',

          //For Verify Your Profile Screen
          'Verify Your Profile': 'Verifica tu perfil',
          'Please enter the 4 digit code you received.': 'Ingrese el código de 4 dígitos que recibió.',
          'Please enter verification code': 'Por favor ingrese el código de verificación',
          'Verify': 'Verificar',
          'Resend Code': 'Reenviar codigo',

          //For Create Change Password Screen
          'Create New Password': 'Crear nueva contraseña',
          'Your new password must be different\n from previously used password': 'Su nueva contraseña debe ser diferente\n de la contraseña utilizada anteriormente',
          'New Password': 'Nueva contraseña',
          'Please enter New Password': 'Por favor ingrese Nueva Contraseña',
          'Must be at least 8 characters': 'Debe tener al menos 8 caracteres',
          'confirm Password': 'Confirmar contraseña',
          'Please enter Confirm Password': 'Por favor ingrese Confirmar contraseña',
          'Both password must match': 'Ambas contraseñas deben coincidir',
          'Save': 'Ahorrar',

          //For Password Reset Successfully Screen
          'Password Reset\n Successfully': 'Restablecimiento de contraseña\n con éxito',
          'You have successfully reset your password.\n Please use your new password when logging in.':
              'Ha restablecido correctamente su contraseña.\n Utilice su nueva contraseña cuando inicie sesión.',
          'Please check your email for verification.': 'Por favor revise su correo electrónico para la verificación.',
          'Back To Login': 'Atrás para iniciar sesión',
          'Get Started': 'Empezar',

          //2). Sign Up Module
          //For Sign Up Screen
          'Name': 'Nombre',
          'Date Of Birth': 'Fecha de nacimiento',
          'Email': 'Correo electrónico',
          'Confirm Password': 'Confirmar contraseña',
          'Please enter name': 'Por favor ingrese el nombre',
          'Please enter date of birth': 'Por favor ingrese la fecha de nacimiento',
          'Please enter valid email': 'Por favor introduzca un correo electrónico válido',
          'Please enter confirm password': 'Por favor ingrese confirmar contraseña',
          'Password and Confirm Password must match': 'La contraseña y Confirmar contraseña deben coincidir',
          'Next': 'Próxima',
          'Already have an account?': '¿Ya tienes una cuenta?',
          'Please enter email.': 'Por favor ingrese el correo electrónico.',

          //For Sign Up Preference Screen
          'Gender': 'Género',
          'Male': 'Masculino',
          'Female': 'Femenina',
          'Transgender': 'Transgénero',
          'Visible on profile': 'Visible en el perfil',
          'Sexual Orientation': 'Orientación sexual',
          'Straight': 'Derecho',
          'Bisexual': 'Bisexual',
          'Lesbian': 'lesbiana',
          'Gay': 'homosexual',
          'Ethnicity': 'Etnicidad',
          'White': 'Blanco',
          'Hispanic or Latino': 'Hispano o latino',
          'Asian': 'Asiático',
          'Black or African': 'Negro o africano',
          'Multiracial': 'Multirracial',

          //For Sign Up Travel Screen
          'Trip Style': 'Estilo de viaje',
          'Backpacking': 'Mochilero',
          'Mid-Range': 'Rango medio',
          'Luxury': 'Lujo',
          'Travelling within the next': 'Viajar dentro de los próximos',
          '1-3 Months': '1-3 meses',
          '3-6 Months': '3-6 meses',
          '6-12 Months': '6-12 meses',
          'Destinations': 'Destinos',
          'Meet Now': 'Reunión ahora',

          //For Destination Screen
          'Where do you want to go? Choose 4 destinations': '¿A donde quieres ir? Elige 4 destinos',
          'Choose 4 destinations': 'Elige 4 destinos',
          'You have chosen all 4 destinations. Remove any to change.': 'Has elegido los 4 destinos. Quite cualquiera para cambiar.',

          //For Subscription Pop Up
          'Premium': 'De primera calidad',
          'Subscribe to unlock all of our features! Update your Destinations and Interests as many times as you want and don’t miss any connections':
              '¡Suscríbete para desbloquear todas nuestras funciones! Actualiza tus Destinos e Intereses tantas veces como quieras y no pierdas conexiones',
          'month': 'mes',
          'Continue': 'Continuar',
          'No Thanks': 'No, gracias',

          //For Meet Now Screen
          'What do you love to do? Choose 4 interests': '¿Qué te gusta hacer? Elige 4 intereses',
          'You have chosen all 4 interests. Remove any to change.': 'Has elegido los 4 intereses. Quite cualquiera para cambiar.',

          //For Sign Up Image Screen
          'Referral Code': 'código de referencia',
          'Add Images': 'Añadir imágenes',
          'About me': 'Sobre mí',
          'Camera': 'Cámara',
          'Gallery': 'Galería',
          'Cancel': 'Cancelar',

          //For Terms & Condition Account Screen
          'Account Suspension': 'Suspensión de cuenta',
          'I understand that Gagago is not a dating application and all forms of improper solicitations are prohibited. Any inappropriate behavior reported by 3 users will lead to my account suspension for 30 days and permanent ban if I repeatedly misuse of the service.':
              'Entiendo que Gagago no es una aplicación de citas y que se prohíben todas las formas de solicitudes indebidas. Cualquier comportamiento inapropiado informado por 3 usuarios dará lugar a la suspensión de mi cuenta durante 30 días y la prohibición permanente si hago un mal uso del servicio repetidamente.',

          'Terms & Conditions': 'Términos y condiciones',
          'Welcome to Gagago!\n\nGagago offers a platform that enables users to connect to each other based on common interests, including travel to the same destinations. You must register an account to access and use the service.\n\nThis is a contract between you and Gagago. By creating a Gagago account, you are legally bound by these terms.\n\nWe are continuously working to improve our platform. This means that we may make changes to the service and/or to this Agreement from time to time. You will be notified and required to accept any material changes to the Agreement in order to continue using the service.':
              '¡Bienvenido a Gagago!\n\nGagago ofrece una plataforma que permite a los usuarios conectarse entre sí en función de intereses comunes, incluido viajar a los mismos destinos. Debe registrar una cuenta para acceder y utilizar el servicio.\n\nEste es un contrato entre usted y Gagago. Al crear una cuenta Gagago, estás legalmente obligado por estos términos.\n\nTrabajamos continuamente para mejorar nuestra plataforma. Esto significa que podemos hacer cambios en el servicio y/o en este Acuerdo de vez en cuando. Se le notificará y se le pedirá que acepte cualquier cambio material en el Acuerdo para continuar usando el servicio.',

          'Eligibility': 'Elegibilidad',
          'In order to create an account or use the service, you must: be at least 18 years of age and legally permitted to form a contract with Gagago; be authorized to use the service under the laws of the United States and any other applicable jurisdiction; you have never been convicted of a felony or offense, sex crime, or any crime involving violence.\n\nYou certify under penalty of perjure that the information you use to create an account is true, correct and your own.\n\nYou understand that any content that offends, discriminates or upset any group or individual’s race, ethnicity, national origin, age, religion, gender, identity, sexual orientation, disability, socioeconomic status or expression is not allowed.\n\nYou agree that you will comply with all applicable laws, including your local jurisdiction laws, rules and regulations. You will not add to your profile any travel destination or Hobbies / Interests prohibited by your local authorities. It’s your responsibility to ensure you are authorized and have all required licenses when engaging is certain activities. If you are unsure or have questions about how local laws apply you should seek legal advice.\n\nWe welcome your feedback and strive to provide you with a valuable platform, however, if for any reason you are unsatisfied with the service or cease to agree with our Terms, you must remove your profile from the application. If you fail to remove your profile and try to damage or undermine the application in any way, we will terminate your account and ban you from the service."':
              'Para crear una cuenta o utilizar el servicio, debe: tener al menos 18 años de edad y estar legalmente autorizado para formalizar un contrato con Gagago; estar autorizado para usar el servicio bajo las leyes de los Estados Unidos y cualquier otra jurisdicción aplicable; nunca ha sido condenado por un delito grave o delito, delito sexual o cualquier delito que involucre violencia.\n\nCertifica bajo pena de perjurio que la información que utiliza para crear una cuenta es verdadera, correcta y propia.\n\nUsted entiendo que no se permite ningún contenido que ofenda, discrimine o altere la raza, el origen étnico, el origen nacional, la edad, la religión, el género, la identidad, la orientación sexual, la discapacidad, el estado socioeconómico o la expresión de cualquier grupo o individuo.\n\n cumplir con todas las leyes aplicables, incluidas las leyes, normas y reglamentos de su jurisdicción local. No agregará a su perfil ningún destino de viaje o aficiones/intereses prohibidos por las autoridades locales. Es su responsabilidad asegurarse de estar autorizado y tener todas las licencias requeridas cuando participe en ciertas actividades. Si no está seguro o tiene preguntas sobre cómo se aplican las leyes locales, debe buscar asesoramiento legal.\n\nAgradecemos sus comentarios y nos esforzamos por brindarle una plataforma valiosa, sin embargo, si por alguna razón no está satisfecho con el servicio o deja de está de acuerdo con nuestros Términos, debe eliminar su perfil de la aplicación. Si no elimina su perfil e intenta dañar o socavar la aplicación de alguna manera, cancelaremos su cuenta y le prohibiremos el servicio".',

          'Subscription': 'Suscripción',
          'Unless you cancel your subscription, any service you subscribe for an initial term will be automatically renewed for the same duration at the current fee for such subscription. If you use a third party payment such as Apple or iTunes, you must manage your purchases directly with them to avoid additional billing.\n\nWhile we may offer free periods of advanced features such as filters or changing destinations and interests while keeping all previous connections, you will lose these benefits after the free period expires and your profile will be converted to the free user features without further notice.\n\nUsers based in the European Union may cancel with a full refund within 14 days after subscribing. For all other locations, you may cancel your subscription, without penalty or obligation, and request a refund at any time prior to midnight of the third business day following the date you subscribed. Users can exercise their cancellation right by contacting us.':
              'A menos que cancele su suscripción, cualquier servicio que suscriba por un período inicial se renovará automáticamente por la misma duración a la tarifa actual para dicha suscripción. Si utiliza un pago de terceros, como Apple o iTunes, debe administrar sus compras directamente con ellos para evitar una facturación adicional.\n\nSi bien es posible que ofrezcamos períodos gratuitos de funciones avanzadas, como filtros o cambio de destinos e intereses, manteniendo todos los conexiones, perderá estos beneficios una vez que expire el período gratuito y su perfil se convertirá a las funciones de usuario gratuitas sin previo aviso.\n\nLos usuarios con sede en la Unión Europea pueden cancelar con un reembolso completo dentro de los 14 días posteriores a la suscripción. Para todas las demás ubicaciones, puede cancelar su suscripción, sin penalización ni obligación, y solicitar un reembolso en cualquier momento antes de la medianoche del tercer día hábil posterior a la fecha en que se suscribió. Los usuarios pueden ejercer su derecho de cancelación poniéndose en contacto con nosotros.',

          'Your data, content and information': 'Sus datos, contenido e información',
          'With the exception of your account information, you agree that all information you provide to create an account and in the use of the service will be public and shared with other users, prospective users, third parties, partners and advertisers.\n\nYou can hide your sexual orientation from your profile by enabling the feature on the settings screen for free. Note that if you want to see users of all sexual orientations, you must not hide your own sexual orientation from your profile.\n\nYou grant Gagago a non-exclusive, worldwide, perpetual, irrevocable, royalty-free, sublicensable, transferable right and license (including a waiver of any moral rights) to use, host, store, reproduce, modify, create derivative works of, distribute and publish, without limitation, your content, including for commercialization and advertisement purposes in any domain. The license would permit your content to remain in use even after you cease to be a member of the Application.\n\nYou are not authorized to display any personal, banking or other financial information on your profile and you agree to maintain the security and confidentiality of your password and account information. If you share any personal or account information with others, you do it at your own risk. Gagago, its employees, owners and partners will not be liable for any damage, claims or losses related to the information you share.\n\nYour profile content and messages will be randomly moderated and we reserve the right to suspend or terminate your account at our sole discretion. If your account is suspended or terminated, you will not be refunded for any subscription you have already been charged for.\n\nYou can delete your account at anytime by going to the settings screen on your profile and clicking on “Delete Account”.\n\nYou are responsible and liable if any of your content violates or infringes the intellectual property or privacy rights of any third party.\n\nIf you believe that our content violates a copyright, trademark or any other form of intellectual property of a work you own, you must contact us to notify and request takedown of the content. Your request should include a signature, identification of the work claimed with supporting proof, contact information and a statement under penalty of perjury that you believe your work has been infringed and you are legally authorized to allege the infringement.':
              'Con la excepción de la información de su cuenta, acepta que toda la información que proporcione para crear una cuenta y en el uso del servicio será pública y compartida con otros usuarios, posibles usuarios, terceros, socios y anunciantes.\n\nUsted puede ocultar su orientación sexual de su perfil habilitando la función en la pantalla de configuración de forma gratuita. Tenga en cuenta que si desea ver usuarios de todas las orientaciones sexuales, no debe ocultar su propia orientación sexual de su perfil.\n\nLe otorga a Gagago un derecho no exclusivo, mundial, perpetuo, irrevocable, libre de regalías, sublicenciable y transferible y licencia (incluida la renuncia a cualquier derecho moral) para usar, alojar, almacenar, reproducir, modificar, crear trabajos derivados, distribuir y publicar, sin limitación, su contenido, incluso con fines de comercialización y publicidad en cualquier dominio. La licencia permitiría que su contenido permanezca en uso incluso después de que deje de ser miembro de la Aplicación.\n\nNo está autorizado a mostrar ninguna información personal, bancaria o financiera en su perfil y acepta mantener la seguridad y confidencialidad de su contraseña y la información de su cuenta. Si comparte cualquier información personal o de cuenta con otros, lo hace bajo su propio riesgo. Gagago, sus empleados, propietarios y socios no serán responsables de ningún daño, reclamo o pérdida relacionada con la información que comparta.\n\nEl contenido y los mensajes de su perfil se moderarán aleatoriamente y nos reservamos el derecho de suspender o cancelar su cuenta en nuestro exclusivo criterio. Si su cuenta se suspende o cancela, no se le reembolsará ninguna suscripción por la que ya se le haya cobrado.\n\nPuede eliminar su cuenta en cualquier momento yendo a la pantalla de configuración de su perfil y haciendo clic en "Eliminar cuenta". \n\nUsted es responsable si parte de su contenido viola o infringe la propiedad intelectual o los derechos de privacidad de un tercero.\n\nSi cree que nuestro contenido viola un derecho de autor, una marca registrada o cualquier otra forma de propiedad intelectual de un trabajo de su propiedad, debe comunicarse con nosotros para notificar y solicitar la eliminación del contenido. Su solicitud debe incluir una firma, identificación del trabajo reclamado con prueba de apoyo, información de contacto y una declaración bajo pena de perjurio de que cree que su trabajo ha sido infringido y que está legalmente autorizado para alegar la infracción.',

          'Safety': 'La seguridad',
          'Gagago is a platform dedicated to connect people and facilitate social interaction. However, we are not responsible for the conduct of any user and will not be liable for any losses, scam, harm or death that may occur as a result of the application use. You acknowledge that some users, third parties and activities you may engage with through the application carry inherent dangers and you assume the entire risk arising out of your access to and use of the application.\n\nWe encourage you to use caution when sharing personal information as you should do in any other circumstances. You should conduct your own due diligence in all interactions with other users, whether in person or online.\n\nIf you travel with or meet other members in person, you do it at your own risk. You understand that Gagago does not perform any type of background checks on its members and you are the sole responsible for users you decide to interact with. We suggest that you only meet in public, tell your family and friends where you are going, who you are going to meet and don’t share transportation or accommodation until you are sure it’s safe to do so. It’s your responsibility to use caution.\n\nYou understand that Gagago does not inquire on criminal background of its users and makes no representations as to the conduct or suitability of any member. To the maximum extent permitted by applicable law, you agree to release Gagago and its owners, employees and associates from any claims, losses or actions that might arise from your interactions with other users, including damages of any nature, injuries, disability, harm or death.':
              'Gagago es una plataforma dedicada a conectar personas y facilitar la interacción social. Sin embargo, no somos responsables de la conducta de ningún usuario y no seremos responsables de ninguna pérdida, estafa, daño o muerte que pueda ocurrir como resultado del uso de la aplicación. Usted reconoce que algunos usuarios, terceros y actividades con las que puede participar a través de la aplicación conllevan peligros inherentes y usted asume todo el riesgo que surja de su acceso y uso de la aplicación.\n\nLe recomendamos que tenga cuidado al compartir información personal. información como debería hacerlo en cualquier otra circunstancia. Debe realizar su propia diligencia debida en todas las interacciones con otros usuarios, ya sea en persona o en línea.\n\nSi viaja o se encuentra con otros miembros en persona, lo hace bajo su propio riesgo. Usted comprende que Gagago no realiza ningún tipo de verificación de antecedentes de sus miembros y usted es el único responsable de los usuarios con los que decide interactuar. Le sugerimos que solo se reúna en público, le diga a su familia y amigos a dónde va, con quién se va a encontrar y no comparta el transporte o el alojamiento hasta que esté seguro de que es seguro hacerlo. Es su responsabilidad ser precavido.\n\nUsted comprende que Gagago no investiga los antecedentes penales de sus usuarios y no se responsabiliza de la conducta o idoneidad de ningún miembro. En la medida máxima permitida por la ley aplicable, acepta liberar a Gagago y a sus propietarios, empleados y asociados de cualquier reclamo, pérdida o acción que pueda surgir de sus interacciones con otros usuarios, incluidos daños de cualquier naturaleza, lesiones, discapacidad, daño o muerte.',

          'LGBT': 'LGBT',
          'Due to the nature of Gagago application, we want to provide transparency to other users that you may meet and travel with. Sexual orientation is a data point collected during your account creation and publicly shared, unless you enable the hide mode.\n\nYou must comply with your local jurisdiction laws and regulations in order to use the service. In the event you are located in an unsafe jurisdiction for the LGBT community, for example, in territories where there is criminalization of same-sex preferences between adults, we suggest you to hide your sexual orientation from your profile. You can do so by clicking on “Don’t show my sexual orientation” on the settings screen. This feature is free and your information is considered by our algorithms.\n\nTo learn more about sexual orientation laws by country, we recommend you to visit the ILGA World website.':
              'Debido a la naturaleza de la aplicación Gagago, queremos brindar transparencia a otros usuarios con los que pueda reunirse y viajar. La orientación sexual es un punto de datos recopilado durante la creación de su cuenta y compartido públicamente, a menos que habilite el modo oculto.\n\nDebe cumplir con las leyes y regulaciones de su jurisdicción local para usar el servicio. En caso de que te encuentres en una jurisdicción insegura para la comunidad LGBT, por ejemplo, en territorios donde existe criminalización de las preferencias del mismo sexo entre adultos, te sugerimos que ocultes tu orientación sexual de tu perfil. Puede hacerlo haciendo clic en "No mostrar mi orientación sexual" en la pantalla de configuración. Esta función es gratuita y nuestros algoritmos consideran su información.\n\nPara obtener más información sobre las leyes de orientación sexual por país, le recomendamos que visite el sitio web de ILGA World.',

          'Third Parties': 'Terceros',
          'Gagago will display advertisements, promotions and deals offered by third parties. If you decide to contract with these third parties made available to you through our service, your relationship with them will be solely and directly governed by them. Gagago is not responsible or liable for the availability, suitability, quality or your satisfaction with the products and services offered by such parties.':
              'Gagago mostrará anuncios, promociones y ofertas ofrecidas por terceros. Si decide contratar con estos terceros puestos a su disposición a través de nuestro servicio, su relación con ellos se regirá única y directamente por ellos. Gagago no es responsable de la disponibilidad, idoneidad, calidad o su satisfacción con los productos y servicios ofrecidos por dichas partes.',

          'Indemnification and Limitation of Liability': 'Indemnización y Limitación de Responsabilidad',
          'To the maximum extent permitted by law, you agree to release, indemnify and hold Gagago, its owners and personnel, harmless from and against any costs, expenses and liabilities derived from claims and attorney’s fees arising out of or in any way connected with the use of the service or your breach of these Terms.\n\nOur liability in connection with the application is limited to the fees you paid to us in the 12 months preceding the claim or \$100, whichever is greater.':
              'En la máxima medida permitida por la ley, usted acepta liberar, indemnizar y eximir a Gagago, sus propietarios y personal de cualquier costo, gasto y responsabilidad derivados de reclamos y honorarios de abogados que surjan o estén relacionados de alguna manera con el uso. del servicio o su incumplimiento de estos Términos.\n\nNuestra responsabilidad en relación con la aplicación se limita a las tarifas que nos pagó en los 12 meses anteriores al reclamo o \$100, lo que sea mayor.',

          'Governing law': 'Ley que rige',
          'This Agreement constitutes a binding legal contract between you and Gagago. Any eventual claims arising from your relationship with us will be governed exclusively by the laws of the State of Texas in the United States.\n\nUsers based in the European Union may have additional or different rights, as provided by applicable law.\n\nYou waive any objection in other forum and jury trial. You will not file or join any class or collective action against us, whether in court or in arbitration.\n\nGagago has no obligation to get involved with any disputes you may have with other users or third parties, although we may try to facilitate a resolution.\n\nIf, for any reason, any portion of these Terms and Conditions is declared invalid by a court of a competent jurisdiction, the remainder of the Agreement will remain in force and in effect. This Agreement will continue to apply even if you stop using the application or delete your account.':
              'Este Acuerdo constituye un contrato legal vinculante entre usted y Gagago. Cualquier eventual reclamo que surja de su relación con nosotros se regirá exclusivamente por las leyes del Estado de Texas en los Estados Unidos.\n\nLos usuarios con sede en la Unión Europea pueden tener derechos adicionales o diferentes, según lo dispuesto por la ley aplicable.\n \nRenuncias a cualquier objeción en otro foro y juicio con jurado. No presentará ni se unirá a ninguna acción colectiva o de clase contra nosotros, ya sea en un tribunal o en un arbitraje.\n\nGagago no tiene la obligación de involucrarse en ninguna disputa que pueda tener con otros usuarios o terceros, aunque podemos tratar de facilitar una resolución.\n\nSi, por algún motivo, una parte de estos Términos y condiciones es declarada inválida por un tribunal de una jurisdicción competente, el resto del Acuerdo permanecerá en vigor y en vigor. Este Acuerdo continuará aplicándose incluso si deja de usar la aplicación o elimina su cuenta.',

          'Effective date': 'Fecha efectiva',
          '  October 3rd, 2022': '3 de octubre de 2022',
          'I have read and agree with the above terms and conditions': 'He leído y estoy de acuerdo con los términos y condiciones anteriores',
          'Please accept Terms & Conditions': 'Por favor acepte los Términos y Condiciones',
          'Accept': 'Aceptar',

          //For Successfully Account Created Screen
          'Account has been\n successfully registered': 'La cuenta ha sido\n registrada correctamente',

          //For Home,Mode,User's Settings And User Profile Screen
          'Could not launch': 'no se pudo iniciar',
          'No Data': 'Sin datos',
          'No Data. Please try again later': 'Sin datos. Por favor, inténtelo de nuevo más tarde',
          'Refresh!': '¡Actualizar!',
          'User\'s Current Address Not Available': 'Dirección actual del usuario no disponible',
          'Hey there, check out Gagago and connect with people who have the same interests as you! ':
              '¡Hola, echa un vistazo a Gagago y conéctate con personas que tienen los mismos intereses que tú! ',
          'Your Referral Code is:': 'Su código de referencia es:',
          'Share Profile': 'Compartir perfil',
          'Write Review': 'Escribir un comentario',
          'User Has Been Removed.': 'El usuario ha sido eliminado.',
          'Remove': 'Remover',
          'User Has Been Blocked.': 'El usuario ha sido bloqueado.',
          'Block & Report': 'Bloquear e informar',
          'No Image Available': 'No hay imagen disponible',
          'Destination is Not Available!': '¡El destino no está disponible!',
          'Meet Now is Not Available!!!!!': '¡Conocer ahora no está disponible!',
          'Interest is Not Available!': '¡El interés no está disponible!',
          'NA': 'N / A',
          '... more': '... más',
          'Choose a mode': 'Elige un modo',
          'Travel': 'Viaje',
          'Settings': 'Ajustes',
          'Don\'t show my age': 'No mostrar mi edad',
          'Meet Now Passport': 'Reunirse ahora Pasaporte',
          'I\'m travelling to...': 'estoy viajando a...',
          'Travelling Soon? Change your location to discover peolpe in other locations': '¿Viajando pronto? Cambia tu ubicación para descubrir personas en otras ubicaciones',
          'Show me': 'Muéstrame',
          'Age Between': 'Edad entre',
          'Men': 'Hombres',
          'Women': 'Mujeres',
          'Everyone': 'Todos',
          'No Address': 'Sin dirección',
          'Edit Profile': 'Editar perfil',
          'No Text Available': 'No hay texto disponible',
          'Tap to edit, drag to reorder': 'Toque para editar, arrastre para reordenar',

          //For Personal Info Screen
          'Personal Info': 'Información personal',
          'Phone Number': 'Número de teléfono',
          'Notifications': 'Notificaciones',
          'Change Password': 'Cambia la contraseña',
          'Subscriptions': 'Suscripciones',
          'Contact Us': 'Contacta con nosotros',
          'Blocked Users': 'Usuarios bloqueados',
          'Feedback': 'Retroalimentación',
          'Invite a Friend': 'Invitar a un amigo',
          'Privacy Policy': 'Política de privacidad',
          'Delete Account': 'Borrar cuenta',
          'Logout': 'Cerrar sesión',
          'Log out': 'Cerrar sesión',
          'Do you want to log out?': '¿Quieres cerrar sesión?',

          //For Notification Screen
          'App Notifications': 'Notificaciones de aplicación',
          'New Connections': 'Nuevas conexiones',
          'New Messages': 'Nuevos mensajes',
          'Notification History :': 'Historial de notificaciones:',
          'No Notification Yet!': '¡Sin notificación todavía!',
          '': '',

          //For Payment Successfully Done Screen
          'Payment Successfully Completed': 'Pago completado con éxito',
          'Back': 'atrás',

          //For Change Password Screen
          'Current Password': 'contraseña actual',
          'Please enter current Password': 'Por favor ingrese la contraseña actual',
          'Both passwords must match': 'Ambas contraseñas deben coincidir',
          'Update Password': 'Actualiza contraseña',

          //For User Subscription User Screen
          'You have already purchased this plan.': 'Ya has comprado este plan.',
          'My Active Plan': 'Mi plan activo',
          'Auto Renewal': 'Auto renovación',
          'Duration': 'Duración',
          'Amount': 'Monto',
          'Date Of Purchase': 'Fecha de compra',
          'Renewal Date': 'Fecha de renovación',
          'Change Plan': 'Cambio de plan',

          //For Contact Us Screen
          'Comment': 'Comentario',
          'Submit': 'Enviar',

          //For Blocked User Screen
          'Unblock': 'Desatascar',
          'You haven\'t blocked any user': 'No has bloqueado a ningún usuario',
          'Yes': 'Sí',
          "Has Been Unblocked.": 'ha sido desbloqueado.',
          'Alert': 'Alerta',
          'Do you want to unblock ': 'Quieres desbloquear ',

          //For Feedback Screen
          'Send Feedback': 'Enviar comentarios',
          'Rate Your Experience': 'Califica tu experiencia',
          'What can we do to make Gagago even better?': '¿Qué podemos hacer para que Gagago sea aún mejor?',
          'Write here..': 'Escriba aqui..',

          //For Invite A Friend Screen
          'This is your invite code': 'Este es tu código de invitación',
          'Referral Code Copied!': '¡Código de referencia copiado!',
          'COPY': 'COPIAR',
          'Hey there, check out Gagago and connect with people who have the same interests as you!':
              '¡Hola, echa un vistazo a Gagago y conéctate con personas que tienen los mismos intereses que tú!',
          'SHARE': 'CUOTA',
          'Total Referred : ': 'Total referido:',

          //For Other User Screen
          'Message': 'Mensaje',
          'User\'s Address Not Available': 'Dirección del usuario no disponible',

          //For Connection Screen
          'Connections': 'Conexiones',
          'Gagagoing to ': 'Gaga va a',
          'You are new here!\n No connections yet.': 'Eres nuevo aquí! \ N No hay conexiones todavía.',
          'Tap the globe icon to like a profile': 'Toca el ícono del globo terráqueo para indicar que te gusta un perfil.',
          'and make new connections.': 'y hacer nuevas conexiones.',

          //For Chat Screen
          'Chat': 'Charlar',
          'Search...': 'Búsqueda...',
          'Gagagoing To Paris': 'Gagagoing a París',
          'Tap the globe icon to like a profile. When ': 'Toque el ícono del globo terráqueo para indicar que le gusta un perfil. Cuando ',
          ' you get connections, you can chat here.': 'obtienes conexiones, puedes chatear aquí.',
          'Reply': 'Respuesta',
          'Report': 'Reporte',
          'Send Message...': 'Enviar mensaje...',

          //For Review Screen
          'Flexible': 'Flexible',
          'Positive': 'Positivo',
          'Sense of humor': 'Sentido del humor',
          'Respectful': 'Respetuoso',
          'Honest': 'Honesto',
          'Open mind': 'Mente abierta',
          'Have you met': 'Conoces a',
          'Save & Exit': 'Guardar la salida',
          'Reviews': 'Reseñas',
          'No Comment Available.': 'Ningún comentario disponible.',
          ' Reviews': ' Reseñas',
        },

        //6).For Chinese Language Translation
        'zh_CN': {
          'Welcome!': '欢迎！',
          'Remember Me': '记得我',
          'When you select common destinations and interests, you’ll see suggested connections.': '当您选择共同的目的地和兴趣时，您会看到建议的要连接的个人资料。',
          'Forgot Password?': '忘记密码？',
          'Login': '登录',
          "Don’t have an account? Sign Up": "没有帐户？"
        },

        //7).For Arabic Language Translation
        'ar_AE': {
          'Welcome!': 'أهلا وسهلا!',
          'Remember Me': 'تذكرنى',
          'When you select common destinations and interests, you’ll see suggested connections.': 'عند تحديد الوجهات والاهتمامات المشتركة ، سترى الملفات الشخصية المقترحة للاتصال.',
          'Forgot Password?': 'هل نسيت كلمة السر؟',
          'Login': 'تسجيل الدخول'
        },
      };
}
