// To parse this JSON data, do
//
//     final createCustomerResponse = createCustomerResponseFromMap(jsonString);

import 'dart:convert';

import 'package:f_stripe_card_pay/src/models/models.dart';

class CreateCustomerResponse {
    CreateCustomerResponse({
         id,
         object,
        this.address,
         balance,
         created,
        this.currency,
        this.defaultSource,
         delinquent,
         description,
        this.discount,
        this.email,
         invoicePrefix,
         invoiceSettings,
         livemode,
         metadata,
        this.name,
         nextInvoiceSequence,
        this.phone,
         preferredLocales,
        this.shipping,
         taxExempt,
        this.testClock, 
    }): 
        id = id ?? '', 
        object = object ?? '{}', 
        balance = balance ?? 0, 
        created = created ?? 0, 
        delinquent = delinquent ?? false, 
        description = description ?? '', 
        invoicePrefix = invoicePrefix ?? '', 
        invoiceSettings = invoiceSettings ?? InvoiceSettings(), 
        livemode = livemode ?? false, 
        metadata = metadata ?? MetadataCustomer(), 
        nextInvoiceSequence = nextInvoiceSequence ?? 0, 
        preferredLocales = preferredLocales ?? [], 
        taxExempt = taxExempt ?? '';

    final String id;
    final String object;
    final dynamic address;
    final int balance;
    final int created;
    final dynamic currency;
    final dynamic defaultSource;
    final bool delinquent;
    final String description;
    final dynamic discount;
    final dynamic email;
    final String invoicePrefix;
    final InvoiceSettings invoiceSettings;
    final bool livemode;
    final MetadataCustomer metadata;
    final dynamic name;
    final int nextInvoiceSequence;
    final dynamic phone;
    final List<dynamic> preferredLocales;
    final dynamic shipping;
    final String taxExempt;
    final dynamic testClock; 

    factory CreateCustomerResponse.fromJson(String str) => CreateCustomerResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreateCustomerResponse.fromMap(Map<String, dynamic> json) => CreateCustomerResponse(
        id: json["id"],
        object: json["object"],
        address: json["address"],
        balance: json["balance"],
        created: json["created"],
        currency: json["currency"],
        defaultSource: json["default_source"],
        delinquent: json["delinquent"],
        description: json["description"],
        discount: json["discount"],
        email: json["email"],
        invoicePrefix: json["invoice_prefix"],
        invoiceSettings: InvoiceSettings.fromMap(json["invoice_settings"]),
        livemode: json["livemode"],
        metadata: MetadataCustomer.fromMap(json["metadata"]),
        name: json["name"],
        nextInvoiceSequence: json["next_invoice_sequence"],
        phone: json["phone"],
        preferredLocales: List<dynamic>.from(json["preferred_locales"].map((x) => x)),
        shipping: json["shipping"],
        taxExempt: json["tax_exempt"],
        testClock: json["test_clock"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "object": object,
        "address": address,
        "balance": balance,
        "created": created,
        "currency": currency,
        "default_source": defaultSource,
        "delinquent": delinquent,
        "description": description,
        "discount": discount,
        "email": email,
        "invoice_prefix": invoicePrefix,
        "invoice_settings": invoiceSettings.toMap(),
        "livemode": livemode,
        "metadata": metadata.toMap(),
        "name": name,
        "next_invoice_sequence": nextInvoiceSequence,
        "phone": phone,
        "preferred_locales": List<dynamic>.from(preferredLocales.map((x) => x)),
        "shipping": shipping,
        "tax_exempt": taxExempt,
        "test_clock": testClock,
    };
}

class InvoiceSettings {
    InvoiceSettings({
        this.customFields,
        this.defaultPaymentMethod,
        this.footer,
        this.renderingOptions,
    });

    final dynamic customFields;
    final dynamic defaultPaymentMethod;
    final dynamic footer;
    final dynamic renderingOptions;

    factory InvoiceSettings.fromJson(String str) => InvoiceSettings.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory InvoiceSettings.fromMap(Map<String, dynamic> json) => InvoiceSettings(
        customFields: json["custom_fields"],
        defaultPaymentMethod: json["default_payment_method"],
        footer: json["footer"],
        renderingOptions: json["rendering_options"],
    );

    Map<String, dynamic> toMap() => {
        "custom_fields": customFields,
        "default_payment_method": defaultPaymentMethod,
        "footer": footer,
        "rendering_options": renderingOptions,
    };
}

class MetadataCustomer {
    MetadataCustomer();

    factory MetadataCustomer.fromJson(String str) => MetadataCustomer.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MetadataCustomer.fromMap(Map<String, dynamic> json) => MetadataCustomer(
    );

    Map<String, dynamic> toMap() => {
    };
}
