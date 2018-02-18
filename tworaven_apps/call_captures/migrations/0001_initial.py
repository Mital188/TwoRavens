# -*- coding: utf-8 -*-
# Generated by Django 1.11.4 on 2017-10-24 20:39
from __future__ import unicode_literals

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone
import model_utils.fields


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='ServiceCallEntry',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created', model_utils.fields.AutoCreatedField(default=django.utils.timezone.now, editable=False, verbose_name='created')),
                ('modified', model_utils.fields.AutoLastModifiedField(default=django.utils.timezone.now, editable=False, verbose_name='modified')),
                ('service_type', models.CharField(choices=[('ROOK SERVICE', 'ROOK SERVICE'), ('D3M SERVICE', 'D3M SERVICE'), ('service not specified', 'service not specified')], max_length=100)),
                ('call_type', models.CharField(help_text='Name of D3M call or zeligapp', max_length=255)),
                ('session_id', models.CharField(blank=True, db_index=True, help_text='Used for grouping calls together', max_length=255)),
                ('outgoing_url', models.URLField(blank=True)),
                ('request_msg', models.TextField(blank=True)),
                ('response_msg', models.TextField(blank=True)),
                ('status_code', models.CharField(blank=True, max_length=50)),
                ('success', models.BooleanField(default=False)),
                ('user', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'verbose_name': 'Service Call Request',
                'verbose_name_plural': 'Service Call Requests',
                'ordering': ('-created',),
            },
        ),
    ]