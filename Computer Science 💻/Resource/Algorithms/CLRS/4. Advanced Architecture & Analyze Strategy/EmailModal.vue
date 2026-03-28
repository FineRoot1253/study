<script setup lang="ts">
import { nextTick, ref, watch } from 'vue';
import InputLayout from '@/common/layout/slot/InputLayout.vue';
import { Validator } from "@/public/type/local/Validator";
import { emailValidator } from '@/common/util/ValidationUtil';
import { InputslotProps } from '@/common/type/InputslotProps';
import { onClickOutside } from '@vueuse/core';
import FillCapsuleButtonLayout from '@/common/layout/button/FillCapsuleButtonLayout.vue';
import AlertModalLayout from '@/common/layout/alert/AlertModalLayout.vue';
import ConfirmButton from '@/common/component/ConfirmButton.vue';
import ConfirmCancelButton from '@/common/component/ConfirmCancelButton.vue';
import { FontSize } from '@/common/type/FontSize';
import { useShake } from '@/composable/useShake';
const { isVibration, triggerShake } = useShake();


const alertModal = ref(false);
const alertText = ref('이메일을 정상적으로 입력해주세요.');
const authNum = ref('');

const props = withDefaults(defineProps<{
  show: boolean;
  flag?: boolean;
  placeholder: string;
  validator: Validator;
  type?: string;
  email: string;
  authnumFlag: boolean;
}>(), {
  type: InputslotProps.text,
  flag: true
})

const email = ref(props.email);


const emits = defineEmits<{
  sendNum: [value: string]
  checkNum: [value: string]
  close: []
  ok: [value: string]
}>()

const sendNum = (email: string) => {
  if (!emailValidator.validateVal(email)) {
    alertModal.value = true;
    return;
  }

  emits("sendNum", email);
}

const checkNum = (num: string) => {
  emits("checkNum", num)
}

const onClose = () => {
  emits("close");
}

const onOk = () => {
  const err = props.validator.validateVal(email.value);
  if (!err) {
    alertModal.value = true;
  } else {
    triggerShake();
  }
  email.value = ''
}


const target = ref<HTMLElement | null>(null);
onClickOutside(target, () => {
  onClose();
})

watch(() => props.authnumFlag, async (val) => {
  if (val) {
    await nextTick();
  }
})
</script>

<template>
  <Transition name="modal">
    <div v-if="show" class="modal">
      <div ref="target" :class="['modal__container', { 'modal__container--vibration': isVibration }]">

        <div class="modal__header">
          <slot name="header">이메일 인증</slot>
        </div>

        <div class="modal__body">
          <div class="modal__body--item">
            <input-layout class="item" style="width:auto;" v-model="email" :placeholder="props.placeholder"
              :validator="props.validator" @keyup.enter="sendNum(email)"></input-layout>

            <fill-capsule-button-layout :size="FontSize.MD" @click="sendNum(email)">
              <template #center>
                인증번호 전송
              </template>
            </fill-capsule-button-layout>
          </div>

          <div v-show="props.authnumFlag" class="modal__body--item">
            <input-layout class="item" @keyup.enter="checkNum(authNum)" v-model="authNum"></input-layout>

            <fill-capsule-button-layout @click="checkNum(email)">
              <template #center>인증번호 확인</template>
            </fill-capsule-button-layout>

          </div>

        </div>

        <div v-show="props.authnumFlag" class="modal__body">
          <input-layout style="width:100%;" @keyup.enter="checkNum(authNum)" v-model="authNum"></input-layout>

          <fill-capsule-button-layout @click="checkNum(email)">
            <template #center>인증번호 확인</template>
          </fill-capsule-button-layout>

        </div>

        <div class="modal__hr">
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
    <alert-modal-layout :show="alertModal">
      <template #header>
        다시 한 번 확인 해주세요
      </template>
      <template #body>
        {{ alertText }}
      </template>
      <template #footer>
        <confirm-button @ok="alertModal = false"></confirm-button>
      </template>
    </alert-modal-layout>
  </Teleport>
</template>

<style scoped lang="scss">
@use "@/common/asset/css/global" as *;

.modal {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 50%);
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
  box-shadow: 0 2px 8px rgba(0, 0, 0, 33%);
  transition: all 0.3s ease;
}

.modal__header {
  text-align: left;
  font-weight: bold;
  font-size: font-size(lg);
  margin-bottom: 20px;
}

.modal__body {
  text-align: left;
  font-size: font-size(md);
  display: flex;
  row-gap: 20px;

  flex-direction: column;
  margin-bottom: 10px;

  .modal__body--item {
    display: flex;
    align-items: center;
    column-gap: 10px;

    .item {
      flex-grow: 1;
    }
  }
}

.modal__hr hr {
  border: none; // 기본 테두리 제거
  border-top: 1px solid $black; // 원하는 색과 두께 지정
  margin: 0; // 필요에 따라 여백 조정
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