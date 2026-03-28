<script setup lang="ts">
import { ref } from 'vue';
import InputLayout from '@/common/layout/slot/InputLayout.vue';
import { pwValidator } from '@/common/util/ValidationUtil';
import { RegExpAlertEnum } from '@/public/type/local/ValidatorEnum';
import AlertLayout from "@/common/layout/slot/AlertLayout.vue"
import { InputslotProps } from '@/common/type/InputslotProps';
import { onClickOutside } from '@vueuse/core';
import ConfirmCancelButton from '../component/ConfirmCancelButton.vue';
import { useShake } from '@/composable/useShake';
const { isVibration, triggerShake } = useShake();

const props = (defineProps<{
  show: boolean;
}>())

const emits = defineEmits<{
  close: []
  ok: [oldPassword: string, newPassword: string]
}>()

const onClose = () => {
  emits("close");
}

const pw = ref('');
const newPw = ref('');
const pwCheck = ref('');

const alertModal = ref(false);
const modalText = ref("");

const onOk = () => {
  //기존 비밀번호 Validation
  const pwFlag = pwValidator.validateVal(pw.value);
  //새 비밀번호 Validation
  const newPwFlag = pwValidator.validateVal(newPw.value);
  //새 비밀번호 확인 Validaiton
  const pwCheckFlag = newPw.value == pwCheck.value;

  if (!pwFlag) {
    modalText.value = "기존 비밀번호를 다시 확인해주세요."
    triggerShake();
    alertModal.value = true;
    return;
  } else if (!newPwFlag) {
    modalText.value = "새 비밀번호를 다시 확인해주세요."
    triggerShake();
    alertModal.value = true;
    return;
  } else if (!pwCheckFlag) {
    modalText.value = "비밀번호 확인을 다시 확인해주세요."
    triggerShake();
    alertModal.value = true;
    return;
  } else if (pw.value == newPw.value) {
    modalText.value = "변경하려는 비밀번호가 기존 비밀번호와 동일합니다."
    triggerShake();
    alertModal.value = true;
    return;
  }

  emits("ok", pw.value, newPw.value);

  pw.value = '';
  newPw.value = '';
  pwCheck.value = '';

}

const target = ref<HTMLElement | null>(null);
onClickOutside(target, () => {
  onClose();
})

</script>

<template>
  <Transition name="modal">
    <div v-if="show" class="modal">
      <div ref="target" :class="['modal__container', { 'modal__container--vibration': isVibration }]">
        <div class="modal__header">
          <slot name="header">default header</slot>
        </div>

        <div class="modal__body">
          <label for="pw">기존 비밀번호</label>
          <input-layout id="pw" v-model:="pw" :placeholder="`기존 비밀번호를 입력해주세요`" :type="InputslotProps.password"
            :validator="pwValidator"></input-layout>
        </div>

        <div class="modal__body">
          <label for="pwChk1">새 비밀번호</label>
          <input-layout id="pwChk1" v-model:="newPw" :placeholder="`새 비밀번호를 입력해주세요`" :type="InputslotProps.password"
            :validator="pwValidator"></input-layout>
        </div>

        <div class="modal__body">
          <label for="pwChk2">새 비밀번호 확인</label>
          <input-layout id="pwChk2" v-model:="pwCheck" :placeholder="`새 비밀번호를 확인해주세요`" :type="InputslotProps.password"
            :validator="{ validateVal: (input: string) => (pwValidator.validateVal(input) && input === newPw), errorMessage: RegExpAlertEnum.COMPAREPW }"
            @keyup.enter="onOk()"></input-layout>
        </div>

        <div>
          <hr>
        </div>

        <div class="modal__footer">
          <slot name="footer">
            <confirm-cancel-button @ok="onOk" @close="onClose"></confirm-cancel-button>
          </slot>
        </div>

      </div>
    </div>
  </Transition>

  <Teleport to="body">
    <!-- use the modal component, pass in the prop -->
    <AlertLayout :show="alertModal" :flag="false" @close="alertModal = false">
      <template #header>
        다시 한 번 확인해주세요
      </template>
      <template #body>
        {{ modalText }}
      </template>
    </AlertLayout>
  </Teleport>
</template>

<style lang="scss" scoped>
@use "@/common/asset/css/global" as *;

.modal {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  transition: opacity 0.3s ease;
  overflow-y: auto;
}

.modal__container {
  width: 500px;
  margin: auto;
  padding: 20px;
  background-color: $white;
  border-radius: 15px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  column-gap: 10px;
}

.modal__header {
  text-align: left;
  margin-top: 0;
  font-weight: bold;
  font-size: large;
}

.modal__body {
  text-align: left;
  margin: 20px 0;
}



/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter-from {
  opacity: 0;
}

.modal-leave-to {
  opacity: 0;
}

.modal-enter-from .modal__container,
.modal-leave-to .modal__container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}

.modal__container--vibration {
  animation: vibration 0.1s infinite;
  /* 빠르게 무한 반복 */
}

/* 잘못된 걸 눌렀을 때 진동효과 */
@keyframes vibration {

  0%,
  100% {
    transform: translateX(0);
  }

  20% {
    transform: translateX(-2px);
  }

  40% {
    transform: translateX(2px);
  }

  60% {
    transform: translateX(-2px);
  }

  80% {
    transform: translateX(2px);
  }
}
</style>