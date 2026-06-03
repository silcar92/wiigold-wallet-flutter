const Map<String, String> esES = {
  'initializated_app': 'Cargando...',

  //? /modules/login
  'login.title': 'Inicia sesión en tu cuenta',
  'login.subtitle': 'Introduce tu email y contraseña para iniciar sesión',

  'login.form.emailInput': 'Correo electrónico',
  'login.form.passwordInput': 'Contraseña',
  'login.form.submit': 'Iniciar sesión ',

  'login.recovery': '¿Has olvidado tu contraseña?',

  'login.sing_up.link1': '¿No tienes una cuenta?',
  'login.sing_up.link2': 'Registrate',

  'login.error.wrong_credentials_title': 'Contraseña incorrecta',
  'login.error.wrong_credentials_attempts': 'Te quedan @remaining intento(s) antes de que tu cuenta sea bloqueada.',
  'login.error.wrong_credentials_last_attempt': 'Tu cuenta ha sido bloqueada. Contacta a soporte para desbloquearla.',
  'login.error.wrong_credentials_generic': 'El correo o la contraseña no son correctos.',
  'login.error.account_locked_title': 'Cuenta bloqueada',
  'login.error.account_locked_description': 'Tu cuenta fue bloqueada por múltiples intentos fallidos. Contacta a soporte para desbloquearla.',

  //? /modules/recovery
  'recovery.recovery_view.title_part1': 'Restablecer',
  'recovery.recovery_view.title_part2': 'Contraseña',
  'recovery.recovery_view.subtitle':
      'Escribe tu correo electrónico para restablecer tu contraseña',
  'recovery.recovery_view.form.email_input': 'Correo electrónico',
  'recovery.recovery_view.form.submit': 'Continuar',

  'recovery.recovery_validation_view.title_part1': 'Validación',
  'recovery.recovery_validation_view.title_part2': 'OTP',
  'recovery.recovery_validation_view.subtitle':
      'Enviamos un código OTP a tu correo para validar esta operación',
  'recovery.recovery_validation_view.form.submit': 'Continuar',
  'recovery.recovery_validation_view.resend_code': 'Enviar código de nuevo ',

  'recovery.new_pass_view.title_part1': 'Cambiar',
  'recovery.new_pass_view.title_part2': 'contraseña',
  'recovery.new_pass_view.subtitle':
      '¡Tu contraseña es solo tuya! No la compartas con nadie.',
  'recovery.new_pass_view.form.password_input': 'Nueva contraseña',

  'recovery.new_pass_view.form.password_repeat_input':
      'Repita su nueva contraseña',

  'recovery.new_pass_view.form.submit': 'Continuar',

  'recovery.controller.error_title': 'Error',

  'recovery.controller.resend_wait_title': 'Espera un momento',

  'recovery.controller.resend_wait_description':
      'Debes esperar a que el contador llegue a cero para reenviar el código.',

  'recovery.controller.resend_success_message':
      'Se ha enviado un nuevo código OTP a su email',

  'recovery.controller.passwords_do_not_match':
      'Su contraseña debe coincidir en ambos campos',

  'recovery.controller.password_recovered_success':
      '¡Contraseña recuperada con éxito!',

  //? /modules/register
  'register.person_type.title': 'Tipo de persona',
  'register.person_type.subtitle': 'Selecciona cómo deseas registrarte en WiiGold.',
  'register.person_type.natural_title': 'Persona Natural',
  'register.person_type.natural_description': 'Registro individual para personas físicas.',
  'register.person_type.juridica_title': 'Persona Jurídica',
  'register.person_type.juridica_description': 'Registro para empresas y organizaciones.',
  'register.person_type.continue_button': 'Continuar',

  'register.register_view.title': 'Registrarme',
  'register.register_view.subtitle': 'Por favor ingresa tus datos básicos',

  'register.register_view.form.emailInput': 'Correo electrónico',
  'register.register_view.form.passwordInput': 'Contraseña',

  'register.register_view.form.submit_button': 'Continuar',

  'register.register_view.terms_checkbox':
      'Ya he leído y acepto las políticas de privacidad y los términos del servicio',
  'register.terms_view.accept_prefix': 'Aceptar ',
  'register.terms_view.accept_link': 'términos y condiciones',
  'register.terms_view.privacy_prefix': 'Aceptar ',
  'register.terms_view.privacy_link': 'política de privacidad',

  'register.register_view.login_link_part1': '¿Ya tienes una cuenta?',
  'register.register_view.login_link_part2': 'Iniciar sesión',

  'register.verification_view.sent_link_message':
      'Hemos enviado un enlace de verificación a\n',
  'register.verification_view.check_inbox_message':
      'Revisa tu bandeja de entrada (incluida la carpeta de spam) y verifica tu correo para poder acceder.',

  //? /modules/auth
  'auth.appbar.title': 'Verificación',

  'auth.auth_view.title_part1': 'Verificación \nde ',
  'auth.auth_view.title_part2_highlight': 'identidad',

  'auth.auth_view.subtitle': 'Ubicación',
  'auth.auth_view.form.country_input': 'Pais',
  'auth.auth_view.form.region_input': 'Estado/Region',
  'auth.auth_view.form.address_input': 'Dirección',
  'auth.auth_view.form.zipcode_input': 'Código Postal',

  'auth.auth_view.terms_checkbox':
      'Ya he leído y acepto las políticas de privacidad y los términos del servicio',

  'auth.auth_view.terms_privacy_link': 'Politicas de privacidad',
  'auth.auth_view.terms_conditions_link': 'Términos y condiciones',

  'auth.auth_view.submit_button': 'Verificar',

  'auth.kyc_view.placeholder.loading_text': 'Inicializando cámara...',

  'auth.kyc_view.snackbar.gallery_error_title': 'Error',
  'auth.kyc_view.snackbar.gallery_error_message':
      'No se pudo recuperar la imagen',

  'auth.support_view.title_part1': 'Contactar a\n',
  'auth.support_view.title_part2': 'soporte',

  'auth.support_view.subtitle':
      'Parece que tenemos problemas para verificar tu identidad. No te preocupes! permítenos ayudarte a resolver este asunto',

  'auth.support_view.contact_button': 'Contactar a soporte',
  'auth.support_view.retry_button': 'Reintentar',

  'auth.successfull_view.validated_message': '¡Identidad validada con éxito!',

  'auth.successfull_view.title_part1': 'Selfie de\n',
  'auth.successfull_view.title_part2_highlight': 'Verificación',

  'auth.successfull_view.instructions':
      'Por favor, toma una foto de ti mismo en un lugar bien iluminado, sin accesorios en el rostro. Esto nos ayudará a confirmar que realmente eres tú.',

  'auth.successfull_view.continue_button': 'Continuar',

  'auth.photos_controller.snackbar.camera_error_title': 'Error de Cámara',
  'auth.photos_controller.snackbar.camera_error_message':
      'No se pudo inicializar la cámara',

  'auth.photos_controller.error.no_image_selected': 'No se seleccionó imagen',
  'auth.photos_controller.error.base64_parse': 'Error al procesar la imagen',
  'auth.photos_controller.subtitle.preview': 'Revise la foto tomada',

  'auth.photos_controller.subtitle.selfie':
      'Tome una selfie de su rostro (2/2)',
  'auth.photos_controller.subtitle.document_base':
      'Tome una @position de su ID (1/2)',

  'auth.photos_controller.subtitle.document_position_front': 'foto frontal',
  'auth.photos_controller.subtitle.document_position_back': 'foto trasera',

  'auth.auth_controller.form.success_title': "Verificación existosa",
  'auth.auth_controller.form.success_message':
      "Revisa el estado de tu verificación en Perfil/Estado KYC",

  //? /modules/profile
  'profile.data_view.title': 'Mis datos',
  'profile.data_view.full_name_label': 'Nombre completo',
  'profile.data_view.document_number_label': 'Nro de documento',
  'profile.data_view.email_label': 'Correo electrónico',
  'profile.data_view.phone_number_label': 'Número de teléfono',
  'profile.data_view.birth_date_label': 'Fecha de Nacimiento',
  'profile.data_view.birth_date_hint': 'Selecciona una fecha',
  'profile.data_view.address_label': 'Dirección',
  'profile.data_view.country_label': 'País',
  'profile.data_view.country_hint': 'Selecciona tu país...',
  'profile.data_view.region_label': 'Estado/Región',
  'profile.data_view.postal_code_label': 'Código Postal',
  'profile.data_view.password_prompt':
      'Ingrese su contraseña para validar esta acción',
  'profile.data_view.validate_button': 'Validar',
  'profile.data_view.cancel_button': 'Cancelar',

  'profile.kyc_view.title': 'Estado KYC',
  'profile.kyc_view.subtitle':
      'Tu seguridad es lo primero. El KYC nos ayuda a proteger tu identidad y tus fondos.',
  'profile.kyc_view.status_label': 'Estado: ',
  'profile.kyc_view.verify_button': 'Verificar',

  'profile.view.title': 'Mi perfil',
  'profile.view.my_data_button': 'Mis Datos',
  'profile.view.kyc_status_button': 'Estado KYC',
  'profile.view.privacy_policy_button': 'Políticas de privacidad',
  'profile.view.terms_and_conditions_button': 'Términos y condiciones',
  'profile.view.about_button': 'Acerca de WiiGold',
  'profile.view.security_button': 'Seguridad (2FA)',
  'profile.view.settings_button': 'Configuraciones',
  'profile.view.logout_button': 'Salir',

  //? /modules/profile/controller
  'profile.controller.load_profile_error': 'Error al cargar perfil de usuario',
  'profile.controller.status_not_started': 'No iniciado',
  'profile.controller.status_started': 'Iniciado',
  'profile.controller.status_in_process': 'En procesamiento',
  'profile.controller.status_approved': 'Aprobado',
  'profile.controller.status_manual_review': 'Revisión manual',
  'profile.controller.status_rejected': 'Rechazado',
  'profile.controller.status_resubmission_required': 'Requiere reenvío',
  'profile.controller.status_pending_identity_verification':
      'Pendiente verificación de identidad',
  'profile.controller.status_pending_watchlist_verification':
      'Pendiente verificación en listas restrictivas',
  'profile.controller.status_unknown': 'Estado desconocido',
  'profile.controller.error_title': 'Error',
  'profile.controller.update_data_error': 'Error al actualizar los datos',
  'profile.controller.confirm_dialog_title': 'Confirmar',
  'profile.controller.confirm_dialog_password_message':
      'Esta acción requiere validar su contraseña',
  'profile.controller.change_email_error':
      'Error al cambiar el correo electrónico',

  //? /modules/settings
  'settings.settings_view.title': 'Configuraciones',
  'settings.settings_view.notifications_toggle_label':
      'Permitir notificaciones',

  'settings.language_selector.title': 'Idioma',

  //? /modules/home
  'home.balance_card.view_card_button': 'Ver tarjeta',
  'home.balance_card.copy_button': 'Copiar',
  'home.balance_card.my_address_label': 'Mi dirección',
  'home.home_controller.snackbar_copied': 'Copiado en el portapapeles',
  'home.home_controller.snackbar_copy_error': 'Error al copiar',
  'home.home_controller.username_placeholder': 'En espera...',
  'home.home_controller.verification_error':
      'Error en la verificación de identidad',
  'home.home_controller.verification_incomplete':
      'Verificación de identidad incompleta',
  'home.home_controller.verification_success':
      'Verificación de identidad realizada con éxito',
  'home.home_view.welcome_message': 'Bienvenido/a \n',
  'home.tab_tokens.no_tokens_found': 'No se han encontrado tokens',
  'home.tab_transactions.data_error': 'Error de datos',
  'home.tab_transactions.no_transactions_found':
      'No se han encontrado transacciones',
  'home.tab_transactions.operation_exchange': 'Intercambio',
  'home.tab_transactions.operation_sell': 'Venta',
  'home.tab_transactions.operation_buy': 'Compra',
  'home.tab_transactions.status_completed': 'Completada',
  'home.tab_transactions.status_failed': 'Fallida',
  'home.tab_transactions.status_pending': 'Pendiente',
  'home.tab_transactions.status_under_review': 'En Revisión',
  'home.tab_transactions.status_unknown': 'Desconocido',
  'home.tab_transactions.unknown_recipient': 'Destinatario desconocido',
  'home.transactions_tab_controller.tab_tokens': 'Portafolio',
  'home.transactions_tab_controller.tab_transactions': 'Movimientos',
  'home.verification_alert.continue_button': 'Continuar',
  'home.verification_alert.welcome_title': 'Bienvenido a WiiGold',
  'home.verification_alert.welcome_subtitle':
      'Antes de comenzar, debes realizar el proceso de validación de identidad (KYC)',

  //? /modules/exchange
  'exchange.view.appbar_title': 'Cambia',

  'exchange.view.value_in_usd': 'Valor @value USD',
  'exchange.view.commission': 'Comisión @commission @tokenName',
  'exchange.view.rate': 'Tasa @rate',
  'exchange.view.title_part1': 'Quiero ',
  'exchange.view.title_part2': 'cambiar ',
  'exchange.view.title_part3': 'mis:',
  'exchange.view.available_balance': 'Balance disponible: ',
  'exchange.view.for_label': 'Por:',
  'exchange.view.continue_button': 'Continuar',

  'exchange.confirm_view.title': 'Confirmar',
  'exchange.confirm_view.from_label': 'Vas a cambiar tus:',
  'exchange.confirm_view.to_label': 'Por:',
  'exchange.confirm_view.continue_button': 'Continuar',
  'exchange.confirm_view.return_button': 'Regresar',

  //? /module/send
  'send.view.appbar_title': 'Envía',

  'send.selector_view.title_part1': 'Seleccione el\n',
  'send.selector_view.title_part2': 'token',
  'send.selector_view.unknown_token': 'Token Desconocido',

  'send.view.title_part1': 'Ingresa el \nmonto a ',
  'send.view.title_part2': 'enviar',
  'send.view.amount_hint': '0,00',
  'send.view.available_balance': 'Balance disponible: ',
  'send.view.commission_message':
      'La comisión para esta transacción es de @commission @tokenName',

  'send.view.continue_button': 'Continuar',
  'send.insert_target_view.title_part1': 'Ingresa \ndirección o\n',
  'send.insert_target_view.title_part2': 'correo',
  'send.insert_target_view.target_label': 'Destino',
  'send.insert_target_view.paste_button': 'Pegar',
  'send.insert_target_view.return_button': 'Regresar',
  'send.insert_target_view.scan_qr_button': 'Escanear QR',
  'send.insert_target_view.continue_button': 'Continuar',

  'send.confirm_view.title': 'Vas a\nenviar ',
  'send.confirm_view.to_wallet': 'A la billetera de:\n',
  'send.confirm_view.transaction_fee': 'Comisión de transacción\n',
  'send.confirm_view.enter_pin_message':
      'Ingresa tu pin para confirmar el pago',
  'send.confirm_view.continue_button': 'Continuar',
  'send.confirm_view.modify_button': 'Modificar',

  'send.controller.amount_not_available': 'Monto no disponible',
  'send.controller.token_not_available': 'Token no disponible',

  'send.controller.enter_or_scan_address':
      'Por favor ingresa o escanea una dirección',
  'send.controller.enter_valid_address':
      'Por favor ingresa o escanea una dirección válida',
  'send.controller.incorrect_password': 'Contraseña incorrecta',
  'send.controller.unexpected_error_title': 'Error Inesperado',
  'send.controller.transaction_processing_error':
      'Ocurrió un error al procesar la transacción: @error',

  //? /modules/request
  'request.view.appbar_title': 'Pide',

  'request.selector_view.title_part1': 'Seleccione el\n',
  'request.selector_view.title_part2': 'token',
  'request.selector_view.unknown_token': 'Token Desconocido',

  'request.view.title_part1': 'Ingresa el \nmonto a ',
  'request.view.title_part2': 'pedir',
  'request.view.amount_hint': '0,00',
  'request.view.continue_button': 'Continuar',

  'request.share_view.title_part1': 'Elige\n',
  'request.share_view.title_part2': 'como\n',
  'request.share_view.title_part3': 'pedir tus:',
  'request.share_view.generate_qr_button': 'Generar código QR',
  'request.share_view.copy_link_button': 'Copiar link de cobro',
  'request.share_view.share_link_button': 'Compartir link de cobro',
  'request.share_view.qr_title': 'Código de \ncobro',
  'request.share_view.qr_instruction_part1': 'Pide que escaneen \n',
  'request.share_view.qr_instruction_part2': 'este código QR para \n',
  'request.share_view.qr_instruction_part3': 'cobrar tus:',
  'request.share_view.return_button': 'Regresar',
  'request.share_view.back_to_home_button': 'Volver al inicio',

  //? /modules/request/controller
  'request.controller.error_generating_link': 'Error al generar link de cobro',
  'request.controller.link_copied': 'Enlace de cobro copiado al portapapeles',
  'request.controller.error_copying_link': 'Error al copiar enlace de cobro',
  'request.controller.share_link_text':
      'Aquí tienes el enlace de cobro para @amount @tokenName: @link',
  'request.controller.share_link_subject': 'Link de cobro - @amount @tokenName',

  //? /modules/token

  //? /modules/token/sell
  'sell.selector_view.title_part1': 'Seleccione el\n',
  'sell.selector_view.title_part2': 'token',
  'sell.selector_view.unknown_token': 'Token Desconocido',

  'sell.sell_view.title_part1': 'Vender \n',
  'sell.sell_view.title_part2_highlight': 'Crypto',
  'sell.sell_view.progress_label': '1/2',
  'sell.sell_view.form.sell_label': 'Vas a vender:',
  'sell.sell_view.form.available_balance_label': 'Balance disponible: ',
  'sell.sell_view.form.receive_label': 'Tu recibes:',
  'sell.sell_view.form.submit_button': 'Continuar',

  'sell.sell_data_view.title': 'Datos de consignación',
  'sell.sell_data_view.progress_label': '2/2',
  'sell.sell_data_view.form.account_holder_name_label':
      'Nombre del titular de la cuenta',
  'sell.sell_data_view.form.document_type_label': 'Tipo de documento',
  'sell.sell_data_view.form.document_type_dni': 'DNI',
  'sell.sell_data_view.form.document_type_passport': 'Pasaporte',
  'sell.sell_data_view.form.document_type_drivers_license':
      'Licencia de Conducir',
  'sell.sell_data_view.form.document_number_label': 'Número de documento',
  'sell.sell_data_view.form.bank_account_number_label':
      'Número de cuenta bancaria',
  'sell.sell_data_view.form.bank_name_label': 'Banco',
  'sell.sell_data_view.form.swift_code_label': 'Código SWIFT',
  'sell.sell_data_view.form.submit_button': 'Continuar',
  'sell.sell_data_view.form.back_button': 'Regresar',

  'sell.confirm_sell_view.title': 'Confirmar',
  'sell.confirm_sell_view.sell_label': 'Vas a vender:',
  'sell.confirm_sell_view.receive_label': 'Tu recibes:',
  'sell.confirm_sell_view.submit_button': 'Continuar',
  'sell.confirm_sell_view.back_button': 'Regresar',

  'sell.sell_info.rate_label': 'Tasa @rate USD',
  'sell.sell_info.commission_label': 'Comisión @commission @tokenName',

  'sell.appbar.title': 'Vender',

  //? /modules/token/buy
  'buy.selector_view.title_part1': 'Seleccione el\n',
  'buy.selector_view.title_part2': 'token',
  'buy.selector_view.unknown_token': 'Token Desconocido',

  'buy.buy_controller.snackbar_min_amount_title':
      'Monto mínimo de compra (10 USD) no alcanzado',
  'buy.buy_controller.snackbar_insufficient_tokens_title':
      'No hay suficientes tokens en tesorería',
  'buy.buy_controller.snackbar_unexpected_error_title': 'Error Inesperado',
  'buy.buy_controller.snackbar_unexpected_error_message':
      'Ocurrió un error al procesar la transacción.',

  'buy.buy_data_view.title_part1': 'Datos de \n',
  'buy.buy_data_view.title_part2_highlight': 'pago',
  'buy.buy_data_view.progress_label': '3/3',
  'buy.buy_data_view.form.payment_data_title': 'Datos \nde pago \nde hauv \n',
  'buy.buy_data_view.form.amount_to_pay_label': 'Monto a pagar: \n',
  'buy.buy_data_view.form.payment_proof_label': 'Comprobante de pago',
  'buy.buy_data_view.form.payment_reference_label': 'Referencia de pago',
  'buy.buy_data_view.form.submit_button': 'Continuar',
  'buy.buy_data_view.form.back_button': 'Regresar',

  'buy.buy_view.title_part1': 'Quiero ',
  'buy.buy_view.title_part2_highlight': 'comprar',
  'buy.buy_view.progress_label': 'Monto y forma de pago',
  'buy.buy_view.form.payment_methods_label': 'Formas de pago disponibles',
  'buy.buy_view.form.available_methods_title': 'Métodos Disponibles',
  'buy.buy_view.form.for_label': 'Por:',
  'buy.buy_view.form.you_will_pay_label': 'Pagarás:',
  'buy.buy_view.form.submit_button': 'Continuar',

  'buy.confirm_buy_view.title_part1': 'Confirmar \n',
  'buy.confirm_buy_view.title_part2_highlight': 'Compra',
  'buy.confirm_buy_view.progress_label': '2/3',
  'buy.confirm_buy_view.pay_label': 'Vas a pagar:',
  'buy.confirm_buy_view.for_label': 'Por:',
  'buy.confirm_buy_view.submit_button': 'Continuar',
  'buy.confirm_buy_view.back_button': 'Regresar',

  'buy.appbar.title': 'Comprar',

  'buy.buy_info.rate_label': 'Tasa @rate USD',
  'buy.buy_info.commission_label': 'Comisión @commission @tokenName',

  //? /modules/loan
  'loan.view.no_active_loans_title': 'Sin préstamos activos',
  'loan.view.no_active_loans_description':
      'Aquí verás tus préstamos cuando tengas uno activo.',
  'loan.view.request_loan_button': 'Solicitar préstamo',
  'loan.view.new_loan_button': 'Nuevo préstamo',
  'loan.view.active_loans_title': 'Préstamos activos',
  'loan.view.loan_card_title': 'Préstamo #@reference',
  'loan.view.requested_amount_label': 'Monto solicitado:',
  'loan.view.due_date_label': 'Fecha de vencimiento:',
  'loan.view.locked_collateral_label': 'Colateral bloqueado:',
  'loan.view.payment_progress_label': 'Progreso de pago',
  'loan.view.remaining_balance_label': 'Balance restante:',

  'loan.balance_card.your_balance': 'Balance',
  'loan.balance_card.grams_abbreviation': 'gr',
  'loan.balance_card.gold_equivalent': 'Equivalente en mineral',
  'loan.balance_card.dollar_equivalent': 'Equivalente en dólares',

  'loan.request_view.title_part1': 'Solicitar \n',
  'loan.request_view.title_part2': 'préstamo',
  'loan.request_view.security_notice':
      'Por tu seguridad y la nuestra, las consignaciones solo se realizarán a cuentas bancarias cuyo titular coincida exactamente con el nombre registrado en nuestro sistema.',
  'loan.request_view.enter_amount_label': 'Ingresa el monto a solicitar',
  'loan.request_view.request_limit_label':
      'Con tu balance actual,\npuedes solicitar hasta:',
  'loan.request_view.deposit_time_notice':
      'El monto solicitado será consignado en tu cuenta un día después de completar tu solicitud.',
  'loan.request_view.collateral_required_label': 'Requiere congelar: ',

  'loan.request_view.accept_terms.prefix': 'Aceptar ',
  'loan.request_view.accept_terms.link': 'términos y condiciones',

  'loan.request_view.continue_button': 'Continuar',

  'loan.data_view.title_part1': 'Detalles de consignación del ',
  'loan.data_view.title_part2_highlight': 'préstamo',
  'loan.data_view.security_notice':
      'Las consignaciones solo se realizarán a cuentas bancarias cuyo titular coincida exactamente con el nombre registrado en nuestro sistema.',
  'loan.data_view.account_holder_name_label': 'Nombre del titular de la cuenta',
  'loan.data_view.account_number_label': 'Número de cuenta bancaria',
  'loan.data_view.bank_name_label': 'Banco',
  'loan.data_view.swift_code_label': 'Código SWIFT',
  'loan.data_view.interest_term_label': 'Término de interés',
  'loan.data_view.term_option_label': '@days días / @rate% APY',
  'loan.data_view.select_term_hint': 'Selecciona un término...',
  'loan.data_view.continue_button': 'Continuar',
  'loan.data_view.modify_button': 'Modificar',

  'loan.payment_controller.biometric_reason':
      'Confirma tu identidad para registrar tu pago.',
  'loan.payment_controller.biometric_cancelled_title': 'Cancelado',
  'loan.payment_controller.biometric_cancelled_description':
      'El registro de pago ha sido cancelado.',
  'loan.payment_controller.payment_successful': 'Pago registrado exitosamente',

  'loan.finish_view.title_part1_highlight': '¡Gracias! ',
  'loan.finish_view.title_part2': 'Tu solicitud ha sido procesada con éxito.',
  'loan.finish_view.subtitle':
      'La consignación se realizará al siguiente día hábil en la cuenta que seleccionaste. Recibirás un correo electrónico con los detalles de la transacción.',
  'loan.finish_view.back_button': 'Volver',

  'loan.loan_payment_info.pay_button': 'Ya pagué',

  'loan.detail_view.loan_amount_label': 'Monto del préstamo',
  'loan.detail_view.interest_rate_label': 'Tasa de interés',
  'loan.detail_view.accrued_interest_label': 'Interés acumulado',
  'loan.detail_view.total_paid_label': 'Total abonado',
  'loan.detail_view.current_debt_label': 'Deuda actual',
  'loan.detail_view.due_date_label': 'Fecha límite',
  'loan.detail_view.collateral_label': 'Colateral',
  'loan.detail_view.title_part1': 'Préstamo en curso \n',
  'loan.detail_view.make_payment_button': 'Realizar pago',
  'loan.detail_view.back_button': 'Volver',

  'loan.payment_view.amount_form.title_part1': 'Monto de ',
  'loan.payment_view.amount_form.title_part2_highlight': 'pago',
  'loan.payment_view.amount_form.amount_hint': '0,00',
  'loan.payment_view.amount_form.max_button': 'Max',
  'loan.payment_view.amount_form.remaining_debt_label': 'Deuda restante: ',
  'loan.payment_view.amount_form.continue_button': 'Continuar',
  'loan.payment_view.amount_form.back_button': 'Regresar',

  'loan.payment_view.method_form.title_part1': 'Comprobante de ',
  'loan.payment_view.method_form.title_part2_highlight': 'pago',
  'loan.payment_view.method_form.payment_methods_label':
      'Formas de pago disponibles',
  'loan.payment_view.method_form.available_methods_title':
      'Métodos Disponibles',
  'loan.payment_view.method_form.payment_proof_label': 'Comprobante de pago',
  'loan.payment_view.method_form.payment_reference_label': 'Referencia de pago',
  'loan.payment_view.method_form.payment_date_label': 'Fecha de pago',
  'loan.payment_view.method_form.email_label': 'Correo electrónico',
  'loan.payment_view.method_form.pay_button': 'Pagar',
  'loan.payment_view.method_form.back_button': 'Regresar',

  'loan.data_controller.invalid_swift_code': 'Código Swift inválido',
  'loan.data_controller.biometric_reason':
      'Confirma tu identidad para solicitar el préstamo.',
  'loan.data_controller.biometric_cancelled_title': 'Cancelado',
  'loan.data_controller.biometric_cancelled_description':
      'La solicitud de préstamo ha sido cancelada.',

  'loan.request_controller.unexpected_error': 'Ocurrió un error inesperado.',
  'loan.request_controller.invalid_server_response':
      'La respuesta del servidor no es válida.',
  'loan.request_controller.load_info_error':
      'No se pudo cargar la información. Inténtalo de nuevo.',
  'loan.request_controller.insufficient_funds': 'Fondos insuficientes',

  'loan.payment_list.no_payments_found': 'No se han encontrado pagos',
  'loan.payment_list.payments_made_title': 'Pagos realizados',
  'loan.payment_list.amount_in_usd': '@amount USD',

  'loan.appbar_title.title': 'Préstamo',

  //? /modules/redeem
  'redeem.appbar_title.title': 'Canjear',

  'redeem.balance_card.your_balance': 'Tu balance',
  'redeem.balance_card.grams_abbreviation': 'gr',
  'redeem.balance_card.gold_equivalent': 'Equivalente en mineral',
  'redeem.balance_card.dollar_equivalent': 'Equivalente en dólares',

  'redeem.view.no_active_requests_title': 'Sin solicitudes activas',
  'redeem.view.no_active_requests_description':
      'Aquí verás tus solicitudes cuando tengas una activa.',
  'redeem.view.request_physical_gold_button': 'Solicitar mineral físico',
  'redeem.view.new_request_button': 'Nueva solicitud',
  'redeem.view.active_requests_title': 'Solicitudes activas',
  'redeem.view.date_completed': 'Completado el:',
  'redeem.view.date_shipped': 'Enviado el:',
  'redeem.view.date_accepted': 'Aceptado el:',
  'redeem.view.date_quoted': 'Cotizado el:',
  'redeem.view.date_requested': 'Solicitado el:',
  'redeem.view.request_card_title': 'Solicitud #@reference',
  'redeem.view.asset_requested_label': 'Activo solicitado:',
  'redeem.view.shipping_address_label': 'Dirección de envío:',
  'redeem.view.shipping_cost_label': 'Costo de envío:',
  'redeem.view.tracking_number_label': 'Nº de seguimiento:',
  'redeem.view.carrier_label': 'Transportista:',

  'redeem.states.pendingQuote': 'Pendiente de cotización',
  'redeem.states.quoted': 'Cotizado',
  'redeem.states.accepted': 'Aceptado',
  'redeem.states.paymentPending': 'Pago recibido',
  'redeem.states.paymentVerified': 'Pago verificado',
  'redeem.states.processing': 'En proceso',
  'redeem.states.shipped': 'Enviado',
  'redeem.states.delivered': 'Entregado',
  'redeem.states.completed': 'Completado',
  'redeem.states.cancelled': 'Cancelado',
  'redeem.states.rejected': 'Rechazado',
  'redeem.states.default': 'Desconocido',

  'redeem.selector_view.title_part1': 'Seleccione el\n',
  'redeem.selector_view.title_part2': 'token',
  'redeem.selector_view.unknown_token': 'Token Desconocido',

  'redeem.request_view.title_part1': 'Recibir ',
  'redeem.request_view.title_part2_highlight': 'mineral \n',
  'redeem.request_view.title_part3_highlight': 'físico',
  'redeem.request_view.subtitle':
      'Convierte tu inversión en un bien tangible con tan solo unos clics.',
  'redeem.request_view.enter_amount_label': 'Ingresa el monto a solicitar',
  'redeem.request_view.request_limit_label':
      'Con tu balance actual,\npuedes solicitar hasta:',
  'redeem.request_view.grams_abbreviation': 'gr',
  'redeem.request_view.reminder_note':
      'Recuerda que un Token es equivalente a un gramo de mineral.',
  'redeem.request_view.commission_label': 'Comisión: ',
  'redeem.request_view.accept_terms_checkbox': 'Aceptar términos y condiciones',
  'redeem.request_view.continue_button': 'Continuar',

  'redeem.data_view.title_part1': 'Detalles de envío del ',
  'redeem.data_view.title_part2_highlight': 'mineral',
  'redeem.data_view.grams_abbreviation': 'gr',
  'redeem.data_view.full_name_label': 'Nombre completo',
  'redeem.data_view.country_label': 'País',
  'redeem.data_view.country_hint': 'Selecciona tu país...',
  'redeem.data_view.region_label': 'Estado/Región',
  'redeem.data_view.address_label': 'Dirección',
  'redeem.data_view.postal_code_label': 'Código Postal',
  'redeem.data_view.phone_number_label': 'Número de teléfono',
  'redeem.data_view.continue_button': 'Continuar',
  'redeem.data_view.modify_button': 'Modificar',

  'redeem.finish_view.title_part1_highlight': '¡Gracias! ',
  'redeem.finish_view.title_part2': 'Tu solicitud ha sido procesada con éxito.',
  'redeem.finish_view.subtitle':
      'Pronto recibirás un correo electrónico con la cotización de los costos de envío y los pasos a seguir para completar tu canje.',
  'redeem.finish_view.back_button': 'Volver',

  'redeem.controller.load_data_error': 'Ocurrió un error al cargar los datos.',
  'redeem.controller.unexpected_response': 'Respuesta inesperada del servidor.',
  'redeem.controller.amount_not_available_title': 'Monto no disponible',
  'redeem.controller.amount_not_available_description':
      'No tienes balance suficiente de este activo para redimir.',

  'redeem.detail_controller.step_pending_quote': 'Pendiente de Cotización',
  'redeem.detail_controller.step_payment_pending': 'Pago Pendiente',
  'redeem.detail_controller.step_payment_verified': 'Pago Verificado',
  'redeem.detail_controller.step_shipped': 'Enviado',
  'redeem.detail_controller.warning_dialog_title': 'Advertencia',
  'redeem.detail_controller.cancel_dialog_message':
      '¿Desea cancelar esta solicitud de Retiro?',
  'redeem.detail_controller.confirm_button': 'Confirmar',
  'redeem.detail_controller.cancel_button': 'Cancelar',
  'redeem.detail_controller.error_title': 'Error',
  'redeem.detail_controller.tracking_error_title': 'Error de Tracking',
  'redeem.detail_controller.tracking_error_description':
      'No se pudieron obtener los detalles del envío.',
  'redeem.detail_controller.quote_error_title': 'Error de Cotización',
  'redeem.detail_controller.quote_error_description':
      'No se pudo obtener la tasa de cambio para @tokenName.',
  'redeem.detail_controller.the_token': 'el token',
  'redeem.detail_controller.insufficient_balance_title': 'Balance Insuficiente',
  'redeem.detail_controller.insufficient_balance_description':
      'Tu balance de @tokenName no es suficiente.',
  'redeem.detail_controller.step_content_pending_quote':
      'Hemos recibido tu solicitud y estamos generando la cotización.',
  'redeem.detail_controller.step_content_payment_pending_action':
      'Tu cotización fue procesada. El monto total a pagar es de @amount @currency. Por favor, realiza el pago para continuar.',
  'redeem.detail_controller.step_content_payment_pending_verification':
      'Recibimos tu comprobante. Nuestro equipo lo está verificando.',
  'redeem.detail_controller.step_content_payment_form_total':
      'Total a pagar: @amount @currency.\nSube tu comprobante y referencia de pago.',
  'redeem.detail_controller.pay_with_tokens_checkbox': 'Pagar con tokens',
  'redeem.detail_controller.payment_token_label': 'Token de pago',
  'redeem.detail_controller.confirm_payment_button': 'Confirmar pago',
  'redeem.detail_controller.available_payment_methods_label':
      'Formas de pago disponibles',
  'redeem.detail_controller.available_methods_title': 'Métodos Disponibles',
  'redeem.detail_controller.payment_proof_label': 'Comprobante de pago',
  'redeem.detail_controller.payment_reference_label': 'Referencia de pago',
  'redeem.detail_controller.send_proof_button': 'Enviar Comprobante',
  'redeem.detail_controller.accept_button': 'Aceptar',
  'redeem.detail_controller.step_content_payment_verified':
      '¡Pago verificado! Estamos preparando tu pedido para el envío.',

  'redeem.payment_controller.biometric_reason':
      'Confirma tu identidad para registrar tu pago.',
  'redeem.payment_controller.biometric_cancelled_title': 'Cancelado',
  'redeem.payment_controller.biometric_cancelled_description':
      'El registro de pago ha sido cancelado.',
  'redeem.payment_controller.payment_successful':
      'Pago registrado exitosamente',

  'redeem.request_controller.insufficient_balance_error':
      'Balance insuficiente',
  'redeem.request_controller.unknown_error': 'Error desconocido',
  'redeem.request_controller.insufficient_funds_error': 'Fondos insuficientes',

  'redeem.detail_view.title': 'Detalle de Solicitud \n',
  'redeem.detail_view.loading': 'Cargando...',
  'redeem.detail_view.back_button': 'Volver',
  'redeem.detail_view.status_cancelled_message':
      'Esta solicitud fue cancelada y no puede continuar.',
  'redeem.detail_view.status_rejected_message':
      'Esta solicitud fue rechazada por nuestro equipo.',
  'redeem.detail_view.copied_toast_title': 'Copiado',
  'redeem.detail_view.copied_toast_description':
      '@label copiado al portapapeles',
  'redeem.detail_view.link_error_title': 'Error',
  'redeem.detail_view.link_error_description':
      'No se pudo abrir el enlace de seguimiento',
  'redeem.detail_view.fetch_data_error':
      'Error al obtener datos. Toca para reintentar.',
  'redeem.detail_view.delivered_status': '¡Entregado!',
  'redeem.detail_view.carrier_label': 'Transportista: @carrier',
  'redeem.detail_view.tracking_label': 'Tracking: @trackingCode',
  'redeem.detail_view.tracking_number_label_for_copy': 'Número de tracking',
  'redeem.detail_view.shipping_history_label': 'Historial del envío:',
  'redeem.detail_view.view_on_carrier_website_button':
      'Ver en la web del transportista',

  //? /modules/qr
  'qr.view.appbar_title': 'Mi dirección',
  'qr.view.scan_qr_title_part1': 'Escanee este código para ',
  'qr.view.scan_qr_title_part2': 'iniciar su transacción ',

  'qr.view.change_mode_button': 'Escanear un QR',
  'qr.view.change_mode_button_2': 'Mostrar mi QR',

  //? /modules/token
  'token.main_chart.value_label': 'Valor: ',
  'token.main_chart.date_label': 'Fecha: ',

  'token.view.today': ' HOY',
  'token.view.current_balance': 'Balance actual',

  'token.view.buy_button': 'Comprar',
  'token.view.sell_button': 'Vender',
  'token.view.send_button': 'Enviar',
  'token.view.request_button': 'Pedir',
  'token.view.exchange_button': 'Convertir',

  'token.view.no_balance_available': 'Sin balance disponible',
  'token.view.market_indicators': 'Indicadores del mercado',
  'token.view.current_price': 'Precio actual',
  'token.view.daily_change': 'Cambio diario',
  'token.view.data_updated_every_minute': 'Datos actualizados periódicamente',
  'token.view.last_update': 'Última actualización: ',

  //? clain
  'claim.claim_view.title': 'Contáctanos',
  'claim.claim_view.caption':
      'Para cualquier consulta sobre tu cuenta o transacciones, usa las opciones detalladas de abajo. Estamos listos para asistirte.',

  'claim.claim_view.form.name_label': 'Nombre completo',
  'claim.claim_view.form.email_label': 'Correo electrónico',
  'claim.claim_view.form.phone_label': 'Número de teléfono',
  'claim.claim_view.form.message_label': 'Mensaje',

  'claim.claim_view.form.claim_category': 'Tipo de consulta',
  'claim.claim_view.form.claim_category_placeholder':
      'Selecciona una categoría...',

  'claim.claim_view.form.claim': 'Consulta especifica',
  'claim.claim_view.form.claim_placeholder':
      'Selecciona un tipo de consulta...',

  'claim.claim_view.form.submit': 'Enviar',

  'claim.claim_view.success_title': 'Ticket de soporte creado exitosamente',
  'claim.claim_view.success_message':
      'Nos pondremos en contacto contigo a la brevedad',

  //? card
  "card.view.blocked_card_label": "Tarjeta bloqueada",
  "card.view.unfreeze_button": "Descongelar",
  "card.view.freeze_button": "Congelar",
  "card.view.block_button": "Bloquear",
  "card.view.request_physical_card_button": "Solicitar tarjeta física",
  "card.view.recent_movements_title": "Últimos movimientos",
  "card.activate_page.no_card_title": "Aún no tienes una tarjeta",
  "card.activate_page.activate_subtitle":
      "Activa tu tarjeta virtual para empezar a operar.",
  "card.activate_page.activate_button": "Activar mi tarjeta virtual",
  "card.credit_card.card_number_label": "Número de tarjeta",
  "card.credit_card.valid_until_label": "Válido hasta",
  "card.credit_card.cvv_label": "CVV",
  "card.transaction_list.status_completed": "Completado",
  "card.transaction_list.status_pending": "Pendiente",
  "card.transaction_list.status_failed": "Fallido",
  "card.transaction_list.status_unknown": "Desconocido",
  "card.transaction_list.no_transactions_found":
      "No se encontraron transacciones para esta tarjeta.",
  "card.transaction_list.card_purchase_title": "Compra con tarjeta",
  "card.controller.confirm_dialog_title": "Confirmar",
  "card.controller.activate_dialog_message":
      "¿Desea activar su tarjeta virtual? Una vez activa, su tarjeta quedará permanentemente vinculada a su cuenta",
  "card.controller.confirm_button": "Confirmar",
  "card.controller.activation_error_title": "Error al activar",
  "card.controller.activation_success_title": "¡Éxito!",
  "card.controller.activation_success_description":
      "Tu tarjeta virtual ha sido activada.",
  "card.controller.toggle_freeze_error_title": "Error",
  "card.controller.toggle_freeze_success_title": "Éxito",
  "card.controller.card_frozen_message": "Tarjeta congelada exitosamente.",
  "card.controller.card_unfrozen_message": "Tarjeta descongelada exitosamente.",
  "card.controller.block_dialog_title": "Bloquear Tarjeta",
  "card.controller.block_dialog_message":
      "Esta acción es irreversible por parte del usuario. ¿Estás seguro que deseas bloquear tu tarjeta permanentemente?",
  "card.controller.block_dialog_confirm_button": "Sí, bloquear",
  "card.controller.block_dialog_cancel_button": "Cancelar",
  "card.controller.block_success_message": "Tarjeta bloqueada exitosamente.",
  "card.controller.request_physical_error_title": "Error",
  "card.controller.request_physical_success_title": "Solicitud Enviada",
  "card.controller.request_physical_success_description":
      "Tu tarjeta física ha sido solicitada correctamente.",

  //? widgets
  'widgets.dynamic_app_scaffold.logout_title': '¿Cerrar Sesión?',
  'widgets.dynamic_app_scaffold.logout_message':
      '¿Estás seguro de que deseas cerrar sesión?',
  'widgets.dynamic_app_scaffold.exit_title': 'Salir',
  'widgets.dynamic_app_scaffold.exit_message': '¿Desea salir de la aplicación?',
  'widgets.dynamic_app_scaffold.confirm_back_title': '¿Volver?',
  'widgets.dynamic_app_scaffold.confirm_back_message':
      '¿Desea regresar a la página anterior?',

  'widgets.dynamic_app_scaffold.confirm': 'Aceptar',
  'widgets.dynamic_app_scaffold.cancel': 'Cancelar',

  'widgets.dynamic_app_scaffold.go_back_title': 'Regresar',
  'widgets.dynamic_app_scaffold.to_home_message': '¿Desea volver al inicio?',
  'widgets.dynamic_app_scaffold.go_back_button': 'Volver',
  'widgets.dynamic_app_scaffold.to_login_message': '¿Desea volver al login?',

  'widgets.payment_methods_list.no_methods_available':
      'No hay métodos de pago disponibles.',
  'widgets.payment_methods_list.bank_label': 'Banco',
  'widgets.payment_methods_list.holder_label': 'Titular',
  'widgets.payment_methods_list.account_number_label': 'Nro. Cuenta',
  'widgets.payment_methods_list.swift_code_label': 'Código Swift',
  'widgets.payment_methods_list.currency_label': 'Moneda',
  'widgets.payment_methods_list.document_label': 'Documento',
  'widgets.payment_methods_list.email_label': 'Email',
  'widgets.payment_methods_list.copied_success':
      'Datos de pago copiados al portapapeles',
  'widgets.payment_methods_list.copy_error': 'Error al copiar los datos',

  'widgets.dynamic_show_payment_method.default_title': 'Información de pago',
  'widgets.dynamic_show_payment_method.close_button': 'Ok',
  'widgets.dynamic_show_payment_method.no_methods_available':
      'No hay métodos de pago disponibles.',
  'widgets.dynamic_show_payment_method.bank_label': 'Banco',
  'widgets.dynamic_show_payment_method.holder_label': 'Titular',
  'widgets.dynamic_show_payment_method.account_number_label': 'Nro. Cuenta',
  'widgets.dynamic_show_payment_method.swift_code_label': 'Código Swift',
  'widgets.dynamic_show_payment_method.currency_label': 'Moneda',
  'widgets.dynamic_show_payment_method.document_label': 'Documento',
  'widgets.dynamic_show_payment_method.email_label': 'Email',
  'widgets.dynamic_show_payment_method.copied_success':
      'Datos de pago copiados al portapapeles',
  'widgets.dynamic_show_payment_method.copy_error': 'Error al copiar los datos',

  'widgets.phone_input.placeholder': 'Selecciona un código de país',
  'widgets.phone_input.code.placeholder': 'Código',
  'widgets.phone_input.code.search_placeholder': 'Buscar código...',
  'widgets.phone_input.label': 'Número de teléfono',

  'widgets.dynamic_bottom_navigation.send': 'Envía',
  'widgets.dynamic_bottom_navigation.request': 'Pide',
  'widgets.dynamic_bottom_navigation.exchange': 'Cambia',
  'widgets.dynamic_bottom_navigation.buy': 'Comprar',
  'widgets.dynamic_bottom_navigation.sell': 'Vender',

  'widgets.dynamic_bottom_navigation.card': 'Tarjeta',
  'widgets.dynamic_bottom_navigation.qr': 'QR',
  'widgets.dynamic_bottom_navigation.coming_soon': 'Próximamente',

  'widgets.dynamic_qrscanner.default_permission_text':
      'Se requiere permiso de cámara para escanear códigos QR.',
  'widgets.dynamic_qrscanner.default_resume_button': 'Escanear de Nuevo',
  'widgets.dynamic_qrscanner.grant_permission_button': 'Conceder Permiso',

  'widgets.term_and_conditions.failed':
      'No se pudo obtener el documento. Inténtalo de nuevo',
  'widgets.term_and_conditions.error': 'No se pudo abrir el enlace',

  'widgets.redirect_clain_form.part_1': '¿Experimenta algún error? ',
  'widgets.redirect_clain_form.part_2': 'Contáctanos',

  //? /modules/screens
  'screens.transaction_status_badge.completed': 'Completado',
  'screens.transaction_status_badge.pending': 'Pendiente',
  'screens.transaction_status_badge.failed': 'Fallido',
  'screens.transaction_status_badge.cancelled': 'Cancelado',
  'screens.transaction_status_badge.under_review': 'En Revisión',
  'screens.transaction_status_badge.unknown': 'Desconocido',

  'screens.transaction_detail.null_transaction': 'Transacción nula',
  'screens.transaction_detail.transaction_id': 'ID de transacción: \n ',
  'screens.transaction_detail.copy_transaction_id': 'Copiar código transacción',
  'screens.transaction_detail.go_to_home': 'Ir al inicio',

  'screens.transaction_detail.controller.default_appbar_title':
      'Detalle de Transacción',
  'screens.transaction_detail.controller.commission_label':
      'Comisión de transacción\n',
  'screens.transaction_detail.controller.loading_details':
      'Cargando detalles...',
  'screens.transaction_detail.controller.status_completed':
      '¡Transacción Completada!',
  'screens.transaction_detail.controller.status_pending':
      'Transacción Pendiente',
  'screens.transaction_detail.controller.status_under_review': 'En Revisión',
  'screens.transaction_detail.controller.status_failed': 'Transacción Fallida',
  'screens.transaction_detail.controller.status_cancelled':
      'Transacción Cancelada',
  'screens.transaction_detail.controller.movement_details_title':
      'Detalle del movimiento',
  'screens.transaction_detail.controller.operation_transferred': 'Transferiste',
  'screens.transaction_detail.controller.operation_transferred_external':
      'Transferiste (Externa)',
  'screens.transaction_detail.controller.operation_deposited': 'Depositaste',
  'screens.transaction_detail.controller.operation_exchanged': 'Cambiaste',
  'screens.transaction_detail.controller.operation_default': 'Operación',
  'screens.transaction_detail.controller.for_label': 'Por',
  'screens.transaction_detail.controller.to_your_account_label': 'A tu cuenta',
  'screens.transaction_detail.controller.received_label': 'Recibiste',
  'screens.transaction_detail.controller.amount_label': 'Monto',
  'screens.transaction_detail.controller.net_amount_label': 'Monto Neto',
  'screens.transaction_detail.controller.commission_label_short': 'Comisión',
  'screens.transaction_detail.controller.you_sent_to': 'Enviaste a:',
  'screens.transaction_detail.controller.to_the_wallet': 'A la billetera:',
  'screens.transaction_detail.controller.you_received_from': 'Recibiste de:',
  'screens.transaction_detail.controller.operation_sold': 'Vendiste',
  'screens.transaction_detail.controller.operation_bought': 'Compraste',
  'screens.transaction_detail.controller.copied_toast_title': 'Copiado',
  'screens.transaction_detail.controller.copied_toast_description':
      'ID de transacción copiado al portapapeles.',

  //? /modules/drawer
  'drawer.view.home': 'Inicio',
  'drawer.view.send': 'Envía',
  'drawer.view.request': 'Pide',
  'drawer.view.scan_qr': 'Escanear QR',
  'drawer.view.request_loan': 'Solicitar préstamo',
  'drawer.view.receive_physical_mineral': 'Recibir mineral físico',
  'drawer.view.my_profile': 'Mi perfil',
  'drawer.view.contact': 'Contacto',
  'drawer.view.logout': 'Salir',

  //? /utils/validation
  'validation.empty_field': 'Campo vacío',

  'validation.password_complexity':
      'La contraseña debe incluir al menos 3 de: minúsculas, mayúsculas, números y caracteres especiales',

  'validation.pass_condition_min_length': 'Mínimo 8 caracteres',
  'validation.pass_condition_lowercase': 'Letras minúsculas (a-z)',
  'validation.pass_condition_uppercase': 'Letras mayúsculas (A-Z)',
  'validation.pass_condition_numbers': 'Números (0-9)',
  'validation.pass_condition_special': 'Caracteres especiales (!@#\$%...)',

  'validation.min_length': 'Mínimo @count caracteres',
  'validation.max_length': 'Máximo @count caracteres',

  'validation.min_value': 'Valor minimo no alcanzado',
  'validation.max_value': 'Valor máximo excedido',

  'validation.invalid_email': 'Correo electrónico inválido',
  'validation.invalid_chars': 'Valor invalido',
  'validation.only_numbers': 'Solo se permiten números',

  "validation.invalid_number": 'Valor numerico inválido',
  'validation.zero_not_allowed': 'Valor numerico inválido',

  "validation.no_spaces_allowed": "No se permiten espacios",
  "validation.invalid_name_chars": "Solo letras, espacios y guiones/apóstrofes",
  "validation.only_letters": "Solo se permiten letras",
  "validation.no_double_spaces": "No se permiten espacios consecutivos",
  "validation.consecutive_special_chars":
      'No se permiten guiones o apóstrofos consecutivos',

  "validation.swift_length": "El SWIFT debe tener 8 u 11 caracteres",
  "validation.swift_invalid": "Formato de SWIFT inválido",

  "validation.only_digits": "Solo se permiten números",
  "validation.only_alphanumeric": "Solo letras y números permitidos",
  "validation.invalid_country_code": "Código de país inválido",
  "validation.invalid_control_digits": "Dígitos de control inválidos",
  "validation.invalid_checksum": "Número de cuenta inválido",

  'validation.invalid_format': "Formato inválido",
  'validation.invalid_month': "Mes inválido",
  'validation.invalid_year': "Año inválido",

  'validation.invalid_card_length': "Longitud de tarjeta inválida",
  'validation.invalid_card_number': "Numero de tarjeta inválida",

  //? generals/forms
  'form.invalidForm_title': 'Error',
  'form.invalidForm_message': 'Formulario inválido',

  'form.invalidForm_error': 'Error: @message',
  'form.invalidForm_unknown': 'Error desconocido: @message',

  //?
  'others.session_expired_title': 'Sesión expirada',
  'others.session_expired_subtitle': 'Inicie sesión nuevamente',

  //? dictionaries
  'errors.AUTH0_EMAIL_ALREADY_REGISTERED':
      'El correo electrónico ya está registrado',
  'errors.AUTH0_EMAIL_UPDATED_ERROR': 'Error al actualizar correo electrónico',
  'errors.AUTH0_ERROR_REGISTERING_USER': 'Error al registrar usuario',
  'errors.AUTH_DATA_UPDATE_ERROR': 'Error al actualizar datos de autenticación',
  'errors.AUTH_USER_NOT_FOUND': 'Usuario de autenticación no encontrado',
  'errors.CONNECTION_ERROR': 'Error de conexión',
  'errors.EMAIL_UNAVAILABLE': 'Correo electrónico no disponible',
  'errors.EMAIL_UNAVAILABLE_LOGIN': 'Correo no asociado a una cuenta',
  'errors.EMAIL_UNAVAILABLE_REGISTER': 'Correo asociado a una cuenta existente',
  'errors.ERROR_CHECK_EMAIL': 'Error al verificar el correo electrónico',
  'errors.ERROR_DELETING_USER': 'Error al eliminar usuario',
  'errors.ERROR_REGISTERING_USER': 'Error al registrar usuario',
  'errors.INVALID_CHECK_EMAIL_DATA':
      'Datos de verificación de correo electrónico inválidos',
  'errors.INVALID_DELETE_ACTION':
      'Debe especificar al menos una acción de eliminación',
  'errors.INVALID_DELETE_USER_DATA':
      'Datos de eliminación de usuario inválidos',
  'errors.INVALID_REGISTRATION_DATA': 'Datos de registro inválidos',
  'errors.LOGOUT_ERROR': 'Error al cerrar sesión',
  'errors.BALANCE_DATA_ERROR': 'Error al obtener los datos de balance',
  'errors.BALANCE_DATA_NOT_FOUND': 'No se encontraron datos de balance',
  'errors.BALANCE_DATA_RETRIEVAL_ERROR':
      'Error al obtener los datos de balance',
  'errors.INVALID_CHANGE_EMAIL_DATA':
      'Datos de cambio de correo electrónico inválidos',
  'errors.INVALID_CHANGE_PASSWORD_DATA':
      'Datos de cambio de contraseña inválidos',
  'errors.PASSWORD_CHANGE_ERROR': 'Error al cambiar contraseña',
  'errors.PASSWORD_CHANGE_OTP_ERROR':
      'Error en el proceso de cambio de contraseña con OTP',
  'errors.PASSWORD_CHANGE_OTP_EXPIRED': 'Código OTP expirado',
  'errors.PASSWORD_CHANGE_OTP_INVALID': 'Código OTP inválido o expirado',
  'errors.PASSWORD_CHANGE_OTP_NOT_FOUND':
      'No se encontró una solicitud de cambio de contraseña',
  'errors.INSUFFICIENT_LIQUIDITY_IN_TREASURY':
      'No hay suficiente liquidez de {code_asset_to} en este momento',
  'errors.TOKEN_CONVERSION_ERROR': 'Error al convertir tokens',
  'errors.TOKEN_CONVERSION_ERROR_INVALID_ASSETS':
      'El activo de origen o destino no es válido',
  'errors.TOKEN_CONVERSION_ERROR_SAME_ASSETS':
      'El activo de origen y destino no pueden ser el mismo',
  'errors.TOKEN_FCM_UPDATE_ERROR': 'Error al actualizar el token de FCM',
  'errors.INVALID_RECOVERY_DATA': 'Datos de recuperación inválidos',
  'errors.PASSWORD_RECOVERY_ERROR':
      'Error al enviar correo de recuperación de contraseña',
  'errors.PASSWORD_RECOVERY_OTP_EXPIRED':
      'Código OTP de recuperación de contraseña expirado',
  'errors.PASSWORD_RECOVERY_OTP_INVALID':
      'Código OTP de recuperación de contraseña inválido',
  'errors.PASSWORD_RECOVERY_OTP_NOT_FOUND':
      'Código OTP de recuperación de contraseña no encontrado',
  'errors.USER_NOT_FOUND': 'Usuario no encontrado',
  'errors.GENERAL_ERROR': 'Error general',
  'errors.UNKNOWN_ERROR': 'Error desconocido',
  'errors.ACTIVE_LOAN_ERROR':
      'Error al obtener información del préstamo activo',
  'errors.ALL_LOANS_ERROR': 'Error al obtener todos los préstamos del usuario',
  'errors.ASSET_NOT_FOUND': 'El asset especificado no fue encontrado',
  'errors.INSUFFICIENT_BALANCE': 'Saldo insuficiente',
  'errors.INSUFFICIENT_COLLATERAL':
      'Colateral insuficiente para el préstamo solicitado',
  'errors.INVALID_LOAN_AMOUNT_DATA': 'Datos de monto de préstamo inválidos',
  'errors.INVALID_LOAN_DATA': 'Datos de préstamo inválidos',
  'errors.INVALID_PAYMENT_DATA': 'Datos de pago inválidos',
  'errors.LIQUIDATION_HISTORY_ERROR':
      'Error al obtener historial de liquidaciones',
  'errors.LOAN_ACCESS_DENIED': 'Acceso denegado al préstamo',
  'errors.LOAN_CAPACITY_CALCULATION_ERROR':
      'Error al calcular capacidad de préstamo',
  'errors.LOAN_CREATION_ERROR': 'Error al crear el préstamo',
  'errors.LOAN_DETAIL_ERROR': 'Error al obtener el detalle del préstamo',
  'errors.LOAN_LIQUIDATION_ERROR': 'Error al liquidar el préstamo',
  'errors.LOAN_NOT_FOUND':
      'El préstamo especificado no existe o no pertenece a este usuario',
  'errors.LOAN_TERMS_ERROR': 'Error al obtener términos de pago',
  'errors.MISSING_LOAN_REFERENCE':
      'Debe especificar la referencia del préstamo al que se aplicará el pago',
  'errors.MISSING_PAYMENT_PROOF': 'El comprobante de pago es requerido',
  'errors.PAYMENT_CREATION_ERROR': 'Error al crear el pago',
  'errors.REQUIRED_TOKENS_CALCULATION_ERROR':
      'Error al calcular tokens requeridos',
  'errors.USER_DEBT_STATUS_ERROR':
      'Error al obtener estado de deuda del usuario',
  'errors.USER_HAS_ACTIVE_LOAN':
      'El usuario ya tiene un préstamo activo o pendiente',
  'errors.USER_HAS_OVERDUE_DEBT':
      'El usuario tiene deuda vencida y acceso limitado',
  'errors.VAULT_NOT_CONFIGURED': 'No hay vault asociada a esta wallet',
  'errors.INVALID_LOGIN_DATA': 'Datos de inicio de sesión inválidos',
  'errors.LOGIN_EMAIL_NOT_VERIFIED':
      'El correo electrónico no está verificado.',
  'errors.LOGIN_ERROR': 'Error al iniciar sesión',
  'errors.LOGIN_WRONG_CREDENTIALS': 'Credenciales inválidas.',
  'errors.INVALID_MINERAL_DATA': 'Datos de mineral inválidos',
  'errors.MINERAL_CREATION_ERROR': 'Error al crear mineral',
  'errors.MINERAL_DATA_RETRIEVAL_ERROR':
      'Error al recuperar datos de minerales',
  'errors.ASSET_NOT_WITHDRAWABLE': 'El token no es retirable',
  'errors.INVALID_MINERAL_WITHDRAWAL_DATA':
      'Datos de retiro de mineral inválidos',
  'errors.MINERAL_WITHDRAWAL_CALCULATION_ERROR':
      'Error al calcular el costo de retiro de mineral',
  'errors.MINERAL_WITHDRAWAL_REQUEST_CREATION_ERROR':
      'Error al crear solicitud de retiro de mineral',
  'errors.MINERAL_WITHDRAWAL_REQUEST_DECISION_ERROR':
      'Error al tomar una decisión sobre la solicitud de retiro de mineral',
  'errors.MINERAL_WITHDRAWAL_REQUEST_DECISION_NOT_QUOTED':
      'La solicitud no está cotizada',
  'errors.MINERAL_WITHDRAWAL_REQUEST_DETAIL_ERROR':
      'Error al obtener la solicitud de retiro de mineral',
  'errors.MINERAL_WITHDRAWAL_REQUEST_LIST_ERROR':
      'Error al obtener las solicitudes de retiro de mineral',
  'errors.MINERAL_WITHDRAWAL_REQUEST_NOT_FOUND':
      'Solicitud de retiro de mineral no encontrada',
  'errors.NOTIFICATIONS_RETRIEVAL_ERROR':
      'Error al recuperar las notificaciones',
  'errors.OFFRAMP_CALCULATION_ERROR': 'Error al calcular off-ramp',
  'errors.OFFRAMP_INSUFFICIENT_BALANCE':
      'Saldo insuficiente para la venta de tokens',
  'errors.OFFRAMP_INVALID_ASSET': 'Activo no válido para off-ramp',
  'errors.OFFRAMP_INVALID_DATA': 'Datos de off-ramp inválidos',
  'errors.OFFRAMP_INVALID_PAYMENT_METHOD': 'Método de pago no válido',
  'errors.OFFRAMP_RATE_NOT_FOUND': 'Tasa de cambio no encontrada',
  'errors.OFFRAMP_REQUEST_ERROR': 'Error al crear solicitud de off-ramp',
  'errors.OFFRAMP_REQUEST_NOT_FOUND': 'Solicitud de off-ramp no encontrada',
  'errors.ONRAMP_CALCULATION_ERROR': 'Error al calcular on-ramp',
  'errors.ONRAMP_INSUFFICIENT_TREASURY_TOKENS':
      'No hay suficientes tokens en tesorería',
  'errors.ONRAMP_INVALID_ASSET': 'Activo no válido para on-ramp',
  'errors.ONRAMP_INVALID_DATA': 'Datos de on-ramp inválidos',
  'errors.ONRAMP_REQUEST_ERROR': 'Error al crear solicitud de on-ramp',
  'errors.ONRAMP_REQUEST_NOT_FOUND': 'Solicitud de on-ramp no encontrada',
  'errors.INVALID_OTP_DATA': 'Datos de OTP inválidos',
  'errors.OTP_ERROR': 'Error al enviar OTP',
  'errors.OTP_INVALID': 'Código OTP inválido',
  'errors.ERROR_VALIDATING_PASSWORD': 'Error al validar contraseña',
  'errors.INVALID_PASSWORD_DATA': 'Datos de contraseña inválidos',
  'errors.PASSWORD_INVALID': 'Contraseña inválida',
  'errors.PAYMENT_METHOD_BANK_LIST_ERROR':
      'Error al obtener la lista de bancos de métodos de pago',
  'errors.PAYMENT_METHOD_BANK_NOT_FOUND':
      'Banco de método de pago no encontrado',
  'errors.PAYMENT_METHOD_CURRENCY_LIST_ERROR':
      'Error al obtener la lista de monedas de métodos de pago',
  'errors.PAYMENT_METHOD_LIST_ERROR':
      'Error al obtener la lista de métodos de pago',
  'errors.PAYMENT_METHOD_NOT_FOUND': 'Método de pago no encontrado',
  'errors.PAYMENT_METHOD_TYPE_LIST_ERROR':
      'Error al obtener la lista de tipos de métodos de pago',
  'errors.PROFILE_DATA_RETRIEVAL_ERROR': 'Error al recuperar datos de perfil',
  'errors.PROFILE_NOT_FOUND': 'Perfil de usuario no encontrado',
  'errors.PROFILE_UPDATE_ERROR': 'Error al actualizar datos de perfil',
  'errors.TOKEN_EXPIRED': 'Token de autenticación expirado',
  'errors.TOKEN_UNAUTHORIZED': 'Token no autorizado o inválido',
  'errors.INVALID_DATE_FORMAT': 'Formato de fecha inválido. Use AAAA-MM-DD',
  'errors.INVALID_PAGE_SIZE': 'El tamaño de página debe ser un entero positivo',
  'errors.INVALID_QUOTATION_DATA': 'Datos de cotización inválidos',
  'errors.INVALID_STATUS_FILTER': 'Filtro de estado inválido',
  'errors.INVALID_TRANSACTION_DATA': 'Datos de transacción inválidos',
  'errors.TRANSACTION_CREATION_ERROR': 'Error al crear la transacción',
  'errors.TRANSACTION_HISTORY_ERROR':
      'Error al recuperar historial de transacciones',
  'errors.TRANSACTION_NOT_FOUND': 'Transacción no encontrada',
  'errors.TRANSACTION_QUOTATION_ERROR':
      'Error al calcular cotización de transacción',
  'errors.VERIFF_ATTEMPTS_EXCEEDED':
      'Se han excedido los intentos de verificación',
  'errors.VERIFF_SESSION_CREATION_ERROR':
      'Error al crear sesión de verificación',
  'errors.VERIFF_SESSION_UPDATE_ERROR':
      'Error al actualizar sesión de verificación',
  'errors.WAREHOUSE_CREATION_ERROR': 'Error al crear almacén',
  'errors.INVALID_WALLET_QUERY_PARAMS':
      'Debe proporcionar un correo electrónico o una dirección de wallet',
  'errors.WALLET_ASSET_NOT_FOUND': 'Asset de billetera no encontrado',
  'errors.WALLET_NOT_FOUND':
      'No se encontró una billetera con los datos proporcionados',
  'errors.WALLET_VALIDATION_ERROR': 'Error al validar la billetera',
  'errors.unknown_error_with_key': 'Error desconocido ({key})',

  'success.ACTIVE_LOAN_FOUND': 'Préstamo activo encontrado',
  'success.ALL_LOANS_FOUND':
      'Todos los préstamos del usuario obtenidos exitosamente',
  'success.AUTH0_EMAIL_UPDATED_SUCCESSFULLY':
      'Correo electrónico actualizado exitosamente',
  'success.AUTH_DATA_UPDATED':
      'Datos de autenticación actualizados exitosamente',
  'success.EMAIL_AVAILABLE': 'Correo electrónico disponible',
  'success.EMAIL_UNAVAILABLE': 'Correo electrónico no disponible',
  'success.BALANCE_DATA_RETRIEVED': 'Balance de wallet obtenido exitosamente',
  'success.LOGOUT_SUCCESS': 'Cierre de sesión exitoso',
  'success.SUCCESS': 'Operación exitosa',
  'success.LIQUIDATION_HISTORY_FOUND':
      'Historial de liquidaciones encontrado exitosamente',
  'success.LOAN_CAPACITY_CALCULATED':
      'Capacidad de préstamo calculada exitosamente',
  'success.LOAN_CREATED_SUCCESSFULLY': 'Préstamo creado exitosamente',
  'success.LOAN_DETAIL_FOUND': 'Detalle del préstamo encontrado exitosamente',
  'success.LOAN_LIQUIDATED_SUCCESSFULLY': 'Préstamo liquidado exitosamente',
  'success.LOAN_TERMS_FOUND': 'Términos de pago encontrados exitosamente',
  'success.NO_ACTIVE_LOAN': 'El usuario no tiene préstamos activos',
  'success.NO_LOANS_FOUND': 'El usuario no tiene préstamos registrados',
  'success.LOGIN_SUCCESS': 'Inicio de sesión exitoso',
  'success.MINERAL_CREATED': 'Mineral creado exitosamente',
  'success.MINERAL_DATA_RETRIEVED':
      'Datos de minerales recuperados exitosamente',
  'success.MINERAL_WITHDRAWAL_CALCULATION_SUCCESS':
      'Costo de retiro de mineral calculado exitosamente',
  'success.MINERAL_WITHDRAWAL_REQUEST_CREATED':
      'Solicitud de retiro de mineral creada exitosamente',
  'success.MINERAL_WITHDRAWAL_REQUEST_DECISION_ACCEPTED':
      'Solicitud de retiro de mineral aceptada exitosamente',
  'success.MINERAL_WITHDRAWAL_REQUEST_DECISION_REJECTED':
      'Solicitud de retiro de mineral rechazada exitosamente',
  'success.MINERAL_WITHDRAWAL_REQUEST_DETAIL_SUCCESS':
      'Solicitud de retiro de mineral obtenida exitosamente',
  'success.MINERAL_WITHDRAWAL_REQUEST_LIST_EMPTY':
      'No hay solicitudes de retiro de mineral',
  'success.MINERAL_WITHDRAWAL_REQUEST_LIST_SUCCESS':
      'Solicitudes de retiro de mineral obtenidas exitosamente',
  'success.NOTIFICATIONS_RETRIEVED': 'Notificaciones recuperadas exitosamente',
  'success.OFFRAMP_CALCULATION_SUCCESS':
      'Cálculo de off-ramp realizado exitosamente',
  'success.OFFRAMP_REQUEST_APPROVED':
      'Solicitud de off-ramp aprobada exitosamente',
  'success.OFFRAMP_REQUEST_CREATED':
      'Solicitud de off-ramp creada exitosamente',
  'success.OFFRAMP_REQUEST_PAID': 'Pago de off-ramp procesado exitosamente',
  'success.OFFRAMP_REQUEST_REJECTED': 'Solicitud de off-ramp rechazada',
  'success.ONRAMP_CALCULATION_SUCCESS':
      'Cálculo de on-ramp realizado exitosamente',
  'success.ONRAMP_PAYMENT_RECEIVED': 'Pago de on-ramp recibido exitosamente',
  'success.ONRAMP_REQUEST_COMPLETED':
      'Solicitud de on-ramp completada exitosamente',
  'success.ONRAMP_REQUEST_CREATED': 'Solicitud de on-ramp creada exitosamente',
  'success.ONRAMP_REQUEST_REJECTED': 'Solicitud de on-ramp rechazada',
  'success.OTP_SENT_SUCCESSFULLY': 'OTP enviado exitosamente',
  'success.OTP_VERIFIED_SUCCESSFULLY': 'Código OTP verificado correctamente',
  'success.PASSWORD_CHANGED_SUCCESSFULLY':
      'Contraseña actualizada exitosamente',
  'success.PASSWORD_CHANGE_COMPLETED': 'Contraseña cambiada exitosamente',
  'success.PASSWORD_CHANGE_OTP_REQUESTED':
      'Código OTP enviado para cambio de contraseña',
  'success.PASSWORD_CHANGE_OTP_VERIFIED': 'Código OTP verificado correctamente',
  'success.PASSWORD_RECOVERY_COMPLETED':
      'Recuperación de contraseña completada exitosamente',
  'success.PASSWORD_RECOVERY_OTP_VERIFIED':
      'Código OTP de recuperación de contraseña verificado correctamente',
  'success.PASSWORD_RECOVERY_SENT':
      'Se ha enviado un correo de recuperación de contraseña',
  'success.PASSWORD_VALID': 'Contraseña válida',
  'success.PAYMENT_CREATED_SUCCESSFULLY':
      'Pago creado exitosamente y está pendiente de confirmación',
  'success.PAYMENT_METHOD_BANK_LIST_SUCCESS':
      'Lista de bancos de métodos de pago obtenida exitosamente',
  'success.PAYMENT_METHOD_CURRENCY_LIST_SUCCESS':
      'Lista de monedas de métodos de pago obtenida exitosamente',
  'success.PAYMENT_METHOD_LIST_SUCCESS':
      'Lista de métodos de pago obtenida exitosamente',
  'success.PAYMENT_METHOD_TYPE_LIST_SUCCESS':
      'Lista de tipos de métodos de pago obtenida exitosamente',
  'success.PROFILE_DATA_RETRIEVED': 'Datos de perfil recuperados exitosamente',
  'success.PROFILE_UPDATED': 'Datos de perfil actualizados exitosamente',
  'success.REQUIRED_TOKENS_CALCULATED':
      'Tokens requeridos calculados exitosamente',
  'success.TOKEN_FCM_UPDATED': 'Token de FCM actualizado exitosamente',
  'success.TOKEN_CONVERSION_SUCCESS':
      'Intercambio de tokens completado exitosamente',
  'success.TOKEN_CONVERSION_SUCCESSFULLY_CALCULATED':
      'Conversión de tokens exitosa',
  'success.TRANSACTION_CREATED_SUCCESSFULLY': 'Transacción creada exitosamente',
  'success.TRANSACTION_HISTORY_RETRIEVED':
      'Historial de transacciones recuperado exitosamente',
  'success.TRANSACTION_QUOTATION_CALCULATED':
      'Cotización de transacción calculada exitosamente',
  'success.TRANSACTION_RETRIEVED': 'Transacción recuperada exitosamente',
  'success.USER_CREATED_SUCCESSFULLY':
      'Usuario creado exitosamente. Por favor verifica tu correo electrónico',
  'success.USER_DELETED_FROM_AUTH0': 'Usuario eliminado exitosamente de Auth0',
  'success.USER_DELETED_FROM_LOCAL':
      'Usuario eliminado exitosamente de la base de datos local',
  'success.USER_DELETED_SUCCESSFULLY': 'Usuario eliminado exitosamente',
  'success.USER_DEBT_STATUS_FOUND':
      'Estado de deuda del usuario obtenido exitosamente',
  'success.VERIFF_SESSION_CREATED':
      'Sesión de verificación creada exitosamente',
  'success.VERIFF_SESSION_UPDATED':
      'Sesión de verificación actualizada exitosamente',
  'success.WALLET_FOUND': 'Billetera encontrada exitosamente',
  'success.WAREHOUSE_CREATED': 'Almacén creado exitosamente',
  'success.process_completed': 'Proceso completado',

  //? Security / 2FA
  'security.setup_2fa.title': 'Autenticación en dos pasos',
  'security.setup_2fa.subtitle': 'Protege tus transacciones con una app de autenticación (Google Authenticator, Authy, etc.).',
  'security.setup_2fa.open_in_app': 'Abrir con mi app de autenticación',
  'security.setup_2fa.manual_entry': 'Ingreso manual (si no puedes escanear el QR):',
  'security.setup_2fa.enter_code': 'Ingresa el código de 6 dígitos que genera tu app para activar:',
  'security.setup_2fa.activate_button': 'Activar 2FA',
  'security.setup_2fa.enabled_title': '2FA Activo',
  'security.setup_2fa.enabled_subtitle': 'Tus transacciones están protegidas.',
  'security.setup_2fa.disable_prompt': 'Ingresa tu código actual para desactivar el 2FA:',
  'security.setup_2fa.disable_button': 'Desactivar 2FA',
  'security.totp_dialog.title': 'Verificación de seguridad',
  'security.totp_dialog.subtitle': 'Ingresa el código de 6 dígitos de tu app de autenticación.',
  'security.totp_dialog.confirm_button': 'Confirmar',
  'security.totp_dialog.cancel_button': 'Cancelar',
  'security.totp_activated': '2FA activado correctamente',
  'security.totp_disabled': '2FA desactivado',
  'security.totp_code_invalid': 'Código inválido. Debe ser de 6 dígitos.',
  'security.totp_secret_copied': 'Clave copiada al portapapeles',
  'security.totp_open_app_error': 'No se pudo abrir la app de autenticación',
  'security.error_loading': 'Error cargando configuración 2FA',
  'security.error_generic': 'Ocurrió un error. Intenta de nuevo.',

  'document_viewer.tos_title': 'Términos y Condiciones',
  'document_viewer.privacy_title': 'Política de Privacidad',
  'document_viewer.open_external': 'Abrir en navegador',
  'document_viewer.load_error': 'No se pudo cargar el documento. Puedes abrirlo en tu navegador.',
};
